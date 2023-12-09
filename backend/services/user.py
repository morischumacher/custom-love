import random
from typing import List, Annotated, Any, Type
import datetime
from typing import List, Annotated

from fastapi import Depends
from fastapi.security import OAuth2PasswordRequestForm
from fastapi_pagination.ext.sqlmodel import paginate
from geoalchemy2 import Geography
from pydantic import BaseModel, Field, json
from shapely import geometry, wkt
from sqlalchemy import func, or_, and_
from sqlmodel import Session, select
from starlette.requests import Request
from starlette.websockets import WebSocket, WebSocketDisconnect

from backend.algo.exsys import ExSys
from backend.exceptions.bad_request_exception import BadRequestException
from backend.exceptions.credentials_exception import CredentialsException
from backend.exceptions.not_found_exception import NotFoundException
from backend.exceptions.validation_exception import ValidationException
from backend.models.message import Message, message_factory
from backend.models.swipe_status import SwipeStatus, SwipeStatusType
from backend.models.user import User
from backend.repository.repository import create_session
from backend.responses.user_response import UserResponse
from backend.services.message import _save_message
from backend.services.validation.user_validation import validate_new_user
from backend.utils import passwords
from backend.utils.connection_manager import connection_manager
from backend.utils.logger import Logger
from backend.utils.pagination import PaginationParams
from backend.utils.token import create_access_token, get_current_user
from backend.services.expert_system import get_expert_system_by_user_id
from backend.models.interest import Interest


class UserUpdate(BaseModel):
    latitude: float = Field(None, title="Latitude")
    longitude: float = Field(None, title="Longitude")
    swiped: bool = Field(None, title="Swiped")


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
    return paginate(db, select(User).join(SwipeStatus, and_(
        or_(SwipeStatus.user1_id == user.id, SwipeStatus.user2_id == user.id),
        SwipeStatus.status == SwipeStatusType.match)),
                    PaginationParams(size=request.query_params.get("size"),
                                     page=request.query_params.get("page")))


def post_user(user: User, db: Annotated[Session, Depends(create_session)]) -> User:
    """
    Create a user
    :param db: injected database
    :param user: a user object
    :return: a user object
    """
    user_validation: [str] = validate_new_user(user)
    if len(validate_new_user(user)) > 0:
        raise ValidationException(user_validation)

    db.add(user)
    db.commit()
    db.refresh(user)

    return user


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
        if "swiped" in key:
            if datetime.datetime.now() < user.swipe_limit_reset_date:
                if user.swipes_left != 0:
                    user.swipes_left = user.swipes_left - 1
            else:
                user.swipe_limit_reset_date = datetime.datetime.now() + datetime.timedelta(hours=24)
                user.swipes_left = 10

        elif "latitude" in key:
            if updated_user.latitude is not None and updated_user.longitude is not None:
                user.latitude = updated_user.latitude
                user.longitude = updated_user.longitude

                point = geometry.Point(user.longitude, user.latitude)
                wkt_point = wkt.dumps(point)

                user.location = wkt_point

    db.commit()
    db.refresh(user)

    # Create a new instance of UserBase with the data from the updated User instance
    user_base = UserResponse(
        id=user.id,
        first_name=user.first_name,
        last_name=user.last_name,
        email=user.email,
        bio=user.bio,
        date_of_birth=user.date_of_birth,
        job=user.job,
        search_radius=user.search_radius,
        swipes_left=user.swipes_left,
        swipe_limit_reset_date=user.swipe_limit_reset_date,
        latitude=user.latitude,
        longitude=user.longitude,
        gender_identity_id=user.gender_identity_id
    )

    return user_base


def login(form_data: Annotated[OAuth2PasswordRequestForm, Depends()], db: Annotated[Session, Depends(create_session)]):
    user = db.exec(select(User).where(User.email == form_data.username)).first()
    if user is None:
        raise NotFoundException("Username does not exist")

    if not passwords.verify_pwd(form_data.password, user.password):
        raise CredentialsException("Wrong Password")

    access_token = create_access_token(data={"sub": user.email})
    return {"access_token": access_token, "token_type": "bearer", "user": user}


def get_algo_user(algoId: int, user: Annotated[User, Depends(get_current_user)],
                  db: Annotated[Session, Depends(create_session)], request: Request) -> UserResponse | None:

    # Query to get all users in the given radius
    subquery = (
        select([User.location])
        .where(User.id == user.id)
    ).alias("user_location")

    query = (
        select([User])
        .where(
            func.ST_DWithin(
                User.location.cast(Geography),
                subquery.c.location.cast(Geography),
                user.search_radius * 1000
            )
        )
        .where(User.id != user.id)
    )

    # Fetch the query
    users_list = db.exec(query).fetchall()





    match algoId:
        case 1:
            user = random.choice(users_list)
            return db_user_to_response_model_user(user, user.interests)
        case 2:
            return None
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
            user_id_with_highest_prediction, prediction = exsys.predict(users_list)

            user = [user for user in users_list if user.id == user_id_with_highest_prediction][0]
            #return the user with the user.id = user_id_with_highest_prediction
            return db_user_to_response_model_user(user, user.interests)
        case _:
            return None


def db_user_to_response_model_user(user, interests):

    interests_list = []
    for interest in interests:
        interests_list.append(Interest(id=interest.id, name=interest.name, icon=interest.icon))

    return UserResponse(
        id=user.id,
        first_name=user.first_name,
        last_name=user.last_name,
        email=user.email,
        bio=user.bio,
        date_of_birth=user.date_of_birth,
        job=user.job,
        search_radius=user.search_radius,
        swipes_left=user.swipes_left,
        latitude=user.latitude,
        longitude=user.longitude,
        gender_identity_id=user.gender_identity_id,
        interests=interests_list
    )


async def websocket_connect(websocket: WebSocket, user_token: str, db: Annotated[Session, Depends(create_session)]):
    user: User = get_current_user(user_token, db)
    Logger.debug(f"[websocket_connect]: connected on a websocket: {websocket} with the user: {user.id}")

    await connection_manager.connect(websocket, user.id)
    try:
        while True:
            data: Message = message_factory(await websocket.receive_json())
            Logger.debug(f"[websocket_connect]: received a message from: user #{user.id}, contents: {data}")
            data = _save_message(data, db)
            await connection_manager.send_message(data.receiver_id, data)
    except WebSocketDisconnect:
        connection_manager.disconnect(websocket, user.id)
