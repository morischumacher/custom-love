from typing import List, Annotated

from fastapi import Depends
from fastapi.security import OAuth2PasswordRequestForm
from fastapi_pagination.ext.sqlmodel import paginate
from sqlalchemy import func
from sqlmodel import Session, select
from geoalchemy2 import Geography
from starlette.requests import Request
from backend.utils import passwords
from backend.exceptions.credentials_exception import CredentialsException
from backend.exceptions.bad_request_exception import BadRequestException
from backend.exceptions.not_found_exception import NotFoundException
from backend.exceptions.validation_exception import ValidationException
from backend.repository.repository import create_session
from backend.models.user import User
from backend.utils.pagination import PaginationParams
from backend.utils.token import create_access_token
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


def get_users(db: Annotated[Session, Depends(create_session)], request: Request) -> List[User]:
    """
    Returns a list of users
    :return: a list of users
    """
    return paginate(db, select(User), PaginationParams(size=request.query_params.get("size"),
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


def login(form_data: Annotated[OAuth2PasswordRequestForm, Depends()], db: Annotated[Session, Depends(create_session)]):
    user = db.exec(select(User).where(User.email == form_data.username)).first()
    if user is None:
        raise NotFoundException("Username does not exist")

    if not passwords.verify_pwd(form_data.password, user.password):
        raise CredentialsException("Wrong Password")

    access_token = create_access_token(data={"sub": user.email})
    return {"access_token": access_token, "token_type": "bearer"}


def get_nearest_users(user_id: int, db: Annotated[Session, Depends(create_session)], request: Request) -> List[User]:
    distance_in_meters = 5000  # TODO: This should be set to the current users search radius

    subquery = (
        select([User.location])
        .where(User.id == user_id)
    ).alias("user_location")

    query = (
        select([User])
        .where(
            func.ST_DWithin(
                User.location.cast(Geography),
                subquery.c.location.cast(Geography),
                distance_in_meters
            )
        )
        .where(User.id != user_id)
    )
    return paginate(db, query, PaginationParams(size=request.query_params.get("size"), page=request.query_params.get("page")))
