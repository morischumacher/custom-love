from typing import List, Annotated

from fastapi import Depends
from fastapi.security import OAuth2PasswordRequestForm
from sqlmodel import Session, select
from sqlmodel.sql.expression import SelectOfScalar

from backend.exceptions.credentials_exception import CredentialsException
from backend.exceptions.fatal_exception import FatalException
from backend.exceptions.not_found_exception import NotFoundException
from backend.exceptions.validation_exception import ValidationException
from backend.repository.repository import get_engine, create_session
from backend.models.user import User
from backend.security import passwords
from backend.security.token import create_access_token
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


async def login(form_data: Annotated[OAuth2PasswordRequestForm, Depends()], db: Annotated[Session, Depends(create_session)]):
    user = db.exec(select(User).where(User.email == form_data.username)).first()
    if user is None:
        raise NotFoundException("Username does not exist")

    if not passwords.verify_pwd(form_data.password, user.password):
        raise CredentialsException("Wrong Password")

    access_token = create_access_token(data={"sub": user.email})
    return {"access_token": access_token, "token_type": "bearer"}
