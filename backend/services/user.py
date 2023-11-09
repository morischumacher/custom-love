from typing import Annotated
from fastapi import Depends
from sqlmodel import Session, select
from sqlmodel.sql.expression import SelectOfScalar

from backend.exceptions.fatal_exception import FatalException
from backend.exceptions.not_found_exception import NotFoundException
from backend.repository.repository import create_session, get_engine
from backend.models.user import User


def get_user(user_id: int):
    with Session(get_engine()) as session:
        statement = select(User).where(User.id == user_id)
        user: list[User] = session.exec(statement).all()
        if len(user) == 0:
            raise NotFoundException(f"Could not find users with id = {user_id}")
        elif len(user) > 1:
            raise FatalException(f"More than one user for id = {user_id} was found")
    return user


def get_users():
    with Session(get_engine()) as session:
        statement: SelectOfScalar[User] = select(User)
        users: list[User] = session.exec(statement).all()
    return users


def post_user(user: User, db: Annotated[Session, Depends(create_session)]):
    with Session(get_engine()) as session:
        session.add(user)
        session.commit()
        session.refresh(user)
    return user
