import datetime
import random
from typing import List, Annotated
import json
from dotenv import load_dotenv
import os
from fastapi import Depends
from fastapi.security import OAuth2PasswordRequestForm
from fastapi_pagination.ext.sqlmodel import paginate
from geoalchemy2 import functions, Geography
from pydantic import BaseModel, Field
from shapely import geometry, wkt
from sqlalchemy import func, or_, and_, exists, cast, text
from sqlmodel import Session, select
from starlette.requests import Request
from starlette.websockets import WebSocket, WebSocketDisconnect

from backend.algo.exsys import ExSys
from backend.exceptions.bad_request_exception import BadRequestException
from backend.exceptions.credentials_exception import CredentialsException
from backend.exceptions.not_found_exception import NotFoundException
from backend.exceptions.validation_exception import ValidationException
from backend.mapper.user_mapper import map_user_to_user_response_with_interests, map_user_to_user_response
from backend.models.message import Message, message_factory
from backend.models.swipe_status import SwipeStatus, SwipeStatusType
from backend.models.user import User
from backend.repository.repository import create_session
from backend.responses.notification import Notification, NotificationType
from backend.responses.user_response import UserResponse, UserResponseWithInterestsAndDistance
from backend.services.expert_system import get_expert_system_by_user_id
from backend.services.message import _save_message
from backend.services.validation.user_validation import validate_new_user
from backend.utils import passwords
from backend.utils.connection_manager import connection_manager
from backend.utils.logger import Logger
from backend.utils.pagination import PaginationParams
from backend.utils.passwords import hash_pwd
from backend.services.expert_system import update_expert_system
from backend.utils.token import create_access_token, get_current_user
load_dotenv()

class UserUpdate(BaseModel):
    latitude: float = Field(None, title="Latitude")
    longitude: float = Field(None, title="Longitude")
    swiped: bool = Field(None, title="Swiped")
    algo_id: int = Field(None, title="AlgoId")


def get_user(user_id: int, db: Annotated[Session, Depends(create_session)]) -> User:
    """
    Return a specific user
    :param db: injected database
    :param user_id: user's id
    :return: a user object
    """
    statement = select(User).where(User.id == user_id)
    user: list[User] = db.exec(statement).all()
    if len(user) == 0:
        raise NotFoundException(f"Could not find users with id = {user_id}")
    elif len(user) > 1:
        raise BadRequestException(f"More than one user for id = {user_id} was found")

    return user[0]


def get_user_by_email(user_email: str, db: Annotated[Session, Depends(create_session)]):
    """
    Return a specific user based on their username (email)
    :param user_email: user email
    :param db: injected database
    :return: a user object
    """
    user = db.exec(select(User).where(User.email == user_email)).first()
    if user is None:
        raise NotFoundException("Username does not exist")

    return user


def get_users(user: Annotated[User, Depends(get_current_user)], db: Annotated[Session, Depends(create_session)],
              request: Request) -> List[User]:
    """
    Retrieves all users, with whom the querying user has a match
    :return: a list of users
    """
    return paginate(db, select(User).join(SwipeStatus, onclause=and_(
        or_(SwipeStatus.user1_id == User.id, SwipeStatus.user2_id == User.id),
                    SwipeStatus.status == SwipeStatusType.match))
                .where(and_(User.id != user.id,
                    or_(SwipeStatus.user1_id == user.id, SwipeStatus.user2_id == user.id))),
                PaginationParams(size=request.query_params.get("size"),
                    page=request.query_params.get("page")))


def registration(user: User, db: Annotated[Session, Depends(create_session)]) -> {}:
    """
    Create a user
    :param db: injected database
    :param user: a user object
    :return: a user object
    """
    # TODO: Verify if password is long enough
    # TODO: Move verification to the database
    user_validation: [str] = validate_new_user(user)
    if len(validate_new_user(user)) > 0:
        raise ValidationException(user_validation)

    user.password = hash_pwd(user.password)
    db.add(user)
    db.commit()
    db.refresh(user)

    access_token = create_access_token(data={"sub": user.email})
    # TODO: Remove sensitive material from the user key-value pair
    return {"access_token": access_token, "token_type": "bearer", "user": user}


def patch_user(updated_user: UserUpdate, user: Annotated[User, Depends(get_current_user)],
               db: Annotated[Session, Depends(create_session)]) -> UserResponse:
    """
        Update a user
        :param db: injected database
        :param user: a user object
        :return: a user object
    """
    # TODO: check if the other fields should be updated
    for key in updated_user.__dict__.items():
        if "swiped" in key and updated_user.swiped is not None:
            if datetime.datetime.now() < user.swipe_limit_reset_date:
                if user.swipes_left != 0:
                    user.swipes_left = user.swipes_left - 1
            else:
                response = update_expert_system(user, db)
                print(response)
                user.swipe_limit_reset_date = datetime.datetime.now() + datetime.timedelta(hours=24)
                user.swipes_left = os.getenv('SWIPE_LIMIT')
        elif "algo_id" in key and updated_user.algo_id is not None:
            user.matching_algorithm = updated_user.algo_id
        elif "latitude" in key:
            if updated_user.latitude is not None and updated_user.longitude is not None:
                user.latitude = updated_user.latitude
                user.longitude = updated_user.longitude

                point = geometry.Point(user.longitude, user.latitude)
                wkt_point = wkt.dumps(point)

                user.location = wkt_point

    db.commit()
    db.refresh(user)
    return map_user_to_user_response(user)


def login(form_data: Annotated[OAuth2PasswordRequestForm, Depends()], db: Annotated[Session, Depends(create_session)]):
    user = db.exec(select(User).where(User.email == form_data.username)).first()
    if user is None:
        raise NotFoundException("Username does not exist")

    if not passwords.verify_pwd(form_data.password, user.password):
        raise CredentialsException("Wrong Password")

    access_token = create_access_token(data={"sub": user.email})
    return {"access_token": access_token, "token_type": "bearer", "user": user}


def get_swipeable_user(user, db):
    subquery = (
        select([User.location])
        .where(User.id == user.id)
    ).alias("user_location")

    query = (
        select([User])
        .where(
            functions.ST_DWithin(
                User.location.cast(Geography),
                subquery.c.location.cast(Geography),
                user.search_radius * 1000
            )
        )
        .where(User.id != user.id)
        .where(
            ~exists(
                select([1])
                .where(
                    or_(
                        and_(SwipeStatus.user2_id == User.id,
                             SwipeStatus.user1_id == user.id,
                             SwipeStatus.status.in_(['view', 'like', 'match'])
                             ),
                        and_(SwipeStatus.user1_id == User.id,
                             SwipeStatus.user2_id == user.id,
                             SwipeStatus.status == 'match'
                             )
                    )
                )
            )
        )
    )
    return db.exec(query).fetchall()


def get_algo_user(algoId: int, user: Annotated[User, Depends(get_current_user)],
                  db: Annotated[Session, Depends(create_session)],
                  request: Request) -> UserResponseWithInterestsAndDistance | None:
    swipeable_user = get_swipeable_user(user, db)
    match algoId:
        case 1:
            swipeable_user_choice = random.choice(swipeable_user)
            return map_user_to_user_response_with_interests(
                swipeable_user_choice,
                get_distance(user, swipeable_user_choice, db)
            )
        case 2:
            return get_user_with_common_interests(user, swipeable_user, db)
        case 3:
            # Get expertsytem of current user
            expert_system = get_expert_system_by_user_id(user.id, db)

            # Get the model of the current user
            current_model = expert_system.model

            # Initialize a Exsys for the current user and set the serialized model, retrieved from the database
            exsys = ExSys(None)
            exsys.deserialize_and_set_model(current_model)

            # Compute the user_id with the highest prediction from the all users in the given radius
            # TODO Use the prediction for something like: "Particularly Compatible! (#65)"
            user_id_with_highest_prediction, prediction = exsys.predict(swipeable_user)

            swipeable_user_choice = [user for user in swipeable_user if user.id == user_id_with_highest_prediction][0]
            # return the user with the user.id = user_id_with_highest_prediction
            return map_user_to_user_response_with_interests(swipeable_user_choice, get_distance(user, swipeable_user_choice, db))
        case _:
            return None


def get_user_with_common_interests(user, swipeable_user_list, db):
    user_interests = set(user.interests)

    most_common_user = max(swipeable_user_list, key=lambda su: len(set(user_interests).intersection(set(su.interests))),
                           default=None)
    return map_user_to_user_response_with_interests(most_common_user, get_distance(user, most_common_user, db)) if most_common_user else None


async def websocket_connect(websocket: WebSocket, user_token: str, db: Annotated[Session, Depends(create_session)]):
    user: User = get_current_user(user_token, db)
    Logger.debug(f"[websocket_connect]: connected on a websocket: {websocket} with the user: {user.id}")

    await connection_manager.connect(websocket, user.id)
    try:
        while True:
            notification: Notification = Notification(await websocket.receive_json())
            # data: Message = message_factory(await websocket.receive_json())
            Logger.debug(
                f"[websocket_connect]: received a notification from: user #{user.id}, contents: {notification}")

            if notification.type == NotificationType.message:
                message: Message = message_factory(notification.content)
                message = _save_message(message, db)
                notification.content = message

                # send the message to the receiver
                await connection_manager.send_notification(message.receiver_id, notification)

                # send the message to all devices of the sender
                await connection_manager.send_notification(message.sender_id, notification)

    except WebSocketDisconnect:
        connection_manager.disconnect(websocket, user.id)


def get_distance(current_user, swipeable_user, db):
    query = text(
        f"""
        SELECT
    ST_DistanceSphere(
        u1.location::geometry,
        u2.location::geometry
    ) AS distance
    FROM
        "user" u1
    JOIN
        "user" u2 ON u1.id = {current_user.id} AND u2.id = {swipeable_user.id};
        """
    )

    result = db.execute(query).first()[0]

    # Distance in km
    distance = round(result / 1000)

    # For safety reasons the lowest km which is shown is 5
    return distance if distance > 5 else 5
