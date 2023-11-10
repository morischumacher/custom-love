from typing import List
from sqlmodel import Session, select
from sqlmodel.sql.expression import SelectOfScalar

from backend.exceptions.fatal_exception import FatalException
from backend.exceptions.not_found_exception import NotFoundException
from backend.exceptions.validation_exception import ValidationException
from backend.repository.repository import get_engine
from backend.models.user import User
from backend.services.validation.user_validation import validate_new_user


def get_user(user_id: int) -> User:
    with Session(get_engine()) as session:
        statement = select(User).where(User.id == user_id)
        user: list[User] = session.exec(statement).all()
        if len(user) == 0:
            raise NotFoundException(f"Could not find users with id = {user_id}")
        elif len(user) > 1:
            raise FatalException(f"More than one user for id = {user_id} was found")
    return user[0]


def get_users() -> List[User]:
    with Session(get_engine()) as session:
        statement: SelectOfScalar[User] = select(User)
        users: list[User] = session.exec(statement).all()
    return users


def post_user(user: User) -> User:
    user_validation: [str] = validate_new_user(user)
    if len(validate_new_user(user)) > 0:
        raise ValidationException(user_validation)

    with Session(get_engine()) as session:
        session.add(user)
        session.commit()
        session.refresh(user)
    return user
