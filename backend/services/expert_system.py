from operator import and_, or_
from typing import Annotated, List
from fastapi import Depends
from sqlmodel import Session, select, update
from backend.algo.exsys import ExSys
from backend.exceptions.bad_request_exception import BadRequestException
from backend.exceptions.not_found_exception import NotFoundException
from backend.models.expert_system import ExpertSystem
from backend.models.swipe_status import SwipeStatus, SwipeStatusType
from backend.models.user import User
from backend.repository.repository import create_session
from backend.utils.token import get_current_user


def get_expert_system_by_user_id(user_id, db: Annotated[Session, Depends(create_session)]):
    """
    Return the expert system from the given user
    :param user_id: id of user of the expert system
    :param db: injected database
    :return: an ExpertSystem object
    """
    statement = select(ExpertSystem).where(ExpertSystem.user_id == user_id)
    expert_system: list[ExpertSystem] = db.exec(statement).all()
    if len(expert_system) == 0:
        raise NotFoundException(f"Could not find expert system for  user with id = {user_id}")
    elif len(expert_system) > 1:
        raise BadRequestException(f"More than one expert systems of user with id = {user_id}")
    return expert_system[0]

# TODO Test in upcoming workflows
def post_expert_system(expert_system: ExpertSystem, db: Annotated[Session, Depends(create_session)]):
    """
    Create an expert system, this function should be only used in sign up process
    :param expert_system: the expert_system to be added
    :param db: injected database
    :return: an ExpertSystem object (with the id)
    """

    db.add(expert_system)
    db.commit()
    db.refresh(expert_system)
    return expert_system


# TODO Test in upcoming workflows
def update_expert_system(user: Annotated[User, Depends(get_current_user)],
                         db: Annotated[Session, Depends(create_session)]):
    """
    Update the given expert system, the user is the same as in the old one
    :param user_id: the user which updating expert system refers to
    :param user: current user
    :param db: injected database
    :return: the new ExpertSystem object (with the id)
    """
    expert_system = None
    try:
        # Get expertsytem of current user
        expert_system = get_expert_system_by_user_id(user.id, db)
    except Exception as e:
        if e is NotFoundException:
            raise NotFoundException(f"Could not find expert system of user with id = {user.id} "
                                    f"when trying to update the expert system")
        elif e is BadRequestException:
            raise BadRequestException(f"More than one expert systems of user with id = {user.id} "
                                      f"where found when trying to update the expert system")

    if expert_system is not None:
        # Get the model of the current user
        current_model = expert_system.model

        # Initialize a Exsys for the current user and set the serialized model, retrieved from the database
        exsys = ExSys(None)
        exsys.deserialize_and_set_model(current_model)

        # Get the recent swipes to update the model
        liked_users = get_liked_users_not_trained_on(db, user.id)
        viewed_users = get_viewed_users_not_trained_on(db, user.id)

        # Update Model of expert system with these users
        exsys.update_model(liked_users, viewed_users)

        # Serialize the updated model and use for the expert system update
        expert_system.model = exsys.serialize_model()

        db.add(expert_system)
        db.commit()
        db.refresh(expert_system)
        return expert_system
    else:
        raise BadRequestException(f"A error occurred when updating the model of the expert system of the user with id ="
                                  f"{user.id}")



def get_liked_users_not_trained_on(db, userid) -> List[User]:
    """
    Retrieves all users, whom the querying user has liked and the expert system isn't trained on yet
    :param db: db instance
    :param userid: id of current user
    :return: a list of users
    """
    statement = (select(User).join(SwipeStatus, onclause=and_(or_(SwipeStatus.user1_id == User.id,
                SwipeStatus.user2_id == User.id), SwipeStatus.status == SwipeStatusType.like))
                 .where(and_(User.id != userid, SwipeStatus.user1_id == userid)))


    user_list = db.exec(statement).all()

    return user_list



def get_viewed_users_not_trained_on(db, userid) -> List[User]:
    """
    Retrieves all users, whom the querying user hasn't liked and the expert system isn't trained on yet
    :param db: db instance
    :param userid: id of current user
    :return: a list of users
    """
    statement = (select(User).join(SwipeStatus, onclause=and_(or_(SwipeStatus.user1_id == User.id,
                SwipeStatus.user2_id == User.id), SwipeStatus.status == SwipeStatusType.view))
                 .where(and_(User.id != userid, SwipeStatus.user1_id == userid)))

    user_list = db.exec(statement).all()

    return user_list