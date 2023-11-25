from typing import Annotated
from fastapi import APIRouter, Depends
from starlette import status

from backend.models.pydantic_user import UserBase
from backend.models.user import User
from backend.responses.error_response import ErrorResponse
from backend.utils.pagination import Page
from backend.utils.token import Token
from backend.services.user import get_user, post_user, patch_user, get_users, login, get_random_users_in_radius, \
    UserUpdate

router = APIRouter(prefix='/users', tags=['users'], responses={status.HTTP_200_OK: {"description": "Success"}})


@router.get("/", response_model=Page[User])
async def get_users(commons: Annotated[Page[User], Depends(get_users)]):
    """
    Retrieves all users stored in the system.
    :return: a list of users
    """
    return commons


@router.get('/{user_id}', response_model=User, responses={
    status.HTTP_404_NOT_FOUND: {"description": "Not Found", "model": ErrorResponse},
    status.HTTP_400_BAD_REQUEST: {"description": "Bad Request", "model": ErrorResponse},
})
def get_user(commons: Annotated[dict, Depends(get_user)]):
    """
    Retrieves a user.
    :return: a user with a corresponding id
    """
    return commons


@router.post('/', response_model=User, responses={
    status.HTTP_422_UNPROCESSABLE_ENTITY: {"description": "Validation Error", "model": ErrorResponse}
})
def post_user(commons: Annotated[dict, Depends(post_user)]):
    """
    Stores a new user.
    :return: the user if stored successfully
    """
    return commons


@router.patch('/', response_model=UserBase, responses={
    status.HTTP_404_NOT_FOUND: {"description": "User not found", "model": ErrorResponse},
    status.HTTP_422_UNPROCESSABLE_ENTITY: {"description": "Validation Error", "model": ErrorResponse}
})
def patch_user(commons: Annotated[UserUpdate, Depends(patch_user)]):
    """
    Update current user information.
    :param db: Database session dependency.
    :return: Updated user.
    """
    return commons


@router.post("/login", response_model=Token)
def login(commons: Annotated[Token, Depends(login)]):
    return commons


@router.get('/algo/random/', response_model=Page[User], responses={
    status.HTTP_404_NOT_FOUND: {"description": "Not Found", "model": ErrorResponse},
    status.HTTP_400_BAD_REQUEST: {"description": "Bad Request", "model": ErrorResponse},
})
def get_random_users_in_radius(commons: Annotated[Page[User], Depends(get_random_users_in_radius)]):
    """
    Retrieves all users in a given search radius
    :return: a user with a corresponding id which is in the search radius
    """
    return commons
