from typing import Annotated
from fastapi import Depends
from sqlmodel import Session, select, update

from backend.exceptions.bad_request_exception import BadRequestException
from backend.exceptions.not_found_exception import NotFoundException
from backend.models.expert_system import ExpertSystem
from backend.repository.repository import create_session


# TODO: Check function.
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
        raise BadRequestException(f"More than one expert systems of user with Id = {user_id}")
    return expert_system[0]


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


def update_expert_system(user_id: int, new_model: bytes, db: Annotated[Session, Depends(create_session)]):
    """
    Update the given expert system, thw user is the same as in the old one
    :param user_id: the user which updating expert system refers to
    :param new_model: the new model for the expert system
    :param db: injected database
    :return: the new ExpertSystem object (with the id)
    """
    expert_system = None
    try:
        expert_system = get_expert_system_by_user_id(user_id, db)
    except Exception as e:
        if e is NotFoundException:
            raise NotFoundException(f"Could not find expert system of user with id = {user_id} "
                                    f"when trying to update the expert system")
        elif e is BadRequestException:
            raise BadRequestException(f"More than one expert systems of user with id = {user_id} "
                                      f"where found when trying to update the expert system")

    if expert_system is not None:
        expert_system.model = new_model
        db.add(expert_system)
        db.commit()
        db.refresh(expert_system)
        return expert_system
    else:
        raise BadRequestException(f"A error occurred when updating the model of the expert system of the user with id ="
                                  f"{user_id}")



