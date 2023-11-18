from typing import List, Annotated

from fastapi import APIRouter, HTTPException, Depends
from starlette import status

from backend import services
from backend.exceptions.fatal_exception import FatalException
from backend.exceptions.not_found_exception import NotFoundException
from backend.exceptions.validation_exception import ValidationException
from backend.models.user import User
from backend.security.token import Token
from backend.services.user import get_user, post_user, login

router = APIRouter(prefix='/users', tags=['users'], responses={404: {"description": "Not found"}})


@router.get("/", response_model=List[User], status_code=status.HTTP_200_OK)
async def get_users() -> List[User]:
    """
    Retrieves all users stored in the system.
    :return: a list of users
    """
    return services.user.get_users()


@router.get('/{user_id}', tags=['get'], response_model=User)
def get_user(user_id: int) -> User:
    """
    Retrieves a user.
    :param user_id: id of the user
    :return: a user with a corresponding id
    """
    try:
        return services.user.get_user(user_id)
    except NotFoundException as e:
        raise HTTPException(status_code=404, detail=e.message)
    except FatalException as e:
        raise HTTPException(status_code=400, detail=e.message)


@router.post('/', tags=['post'], response_model=User)
def post_user(user: User) -> User:
    """
    Stores a new user.
    :param user: registers user's credentials
    :return: the user if stored successfully
    """
    try:
        return services.user.post_user(user)
    except ValidationException as e:
        raise HTTPException(status_code=422, detail=e.message)


@router.post("/login", response_model=Token)
def login(commons: Annotated[Token, Depends(login)]):
    return commons
