from typing import List, Annotated

from fastapi import Depends
from sqlmodel import Session, select
from sqlmodel.sql.expression import SelectOfScalar

from backend.exceptions.bad_request_exception import BadRequestException
from backend.exceptions.not_found_exception import NotFoundException
from backend.exceptions.validation_exception import ValidationException
from backend.repository.repository import get_engine, create_session
from backend.models.user import User
from backend.services.validation.user_validation import validate_new_user


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


def get_users(db: Annotated[Session, Depends(create_session)]) -> List[User]:
    """
    Returns a list of users
    :return: a list of users
    """
    statement: SelectOfScalar[User] = select(User)
    users: list[User] = db.exec(statement).all()

    return users


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
