from typing import Annotated

from fastapi import APIRouter, Depends
from starlette import status

from backend.models.expert_system import ExpertSystem
from backend.models.user import User
from backend.responses.error_response import ErrorResponse
from backend.responses.user_response import UserResponse, UserResponseWithInterests
from backend.services.user import patch_user, get_algo_user, UserUpdate, get_user, registration, get_users, login, \
    websocket_connect, get_user_profile, get_user_by_email
from backend.responses.user_response import UserResponse, UserResponseWithInterestsAndDistance
from backend.services.expert_system import update_expert_system
from backend.services.user import patch_user, get_algo_user, UserUpdate, get_user, get_users, login, registration, \
    websocket_connect
from backend.utils.pagination import Page
from backend.utils.token import Token

router = APIRouter(prefix='/users', tags=['users'], responses={status.HTTP_200_OK: {"description": "Success"}})


@router.get("", response_model=Page[UserResponse])
async def get_users(commons: Annotated[Page[User], Depends(get_users)]):
    """
    Retrieves all users, with whom the querying user has a match
    :return: a list of users
    """
    return commons


@router.get('/{user_id}', responses={
    status.HTTP_404_NOT_FOUND: {"description": "Not Found", "model": ErrorResponse},
    status.HTTP_400_BAD_REQUEST: {"description": "Bad Request", "model": ErrorResponse},
})
def get_user(commons: Annotated[dict, Depends(get_user)]):
    """
    Retrieves a user.
    :return: a user with a corresponding id
    """
    return commons


@router.get('/email/{user_email}', responses={
    status.HTTP_404_NOT_FOUND: {"description": "Not Found", "model": ErrorResponse},
    status.HTTP_400_BAD_REQUEST: {"description": "Bad Request", "model": ErrorResponse},
})
def get_user_by_email(commons: Annotated[dict, Depends(get_user_by_email)]):
    """
    Retrieves a user.
    :return: a user with a corresponding id
    """
    return commons


@router.post('/', responses={
    status.HTTP_422_UNPROCESSABLE_ENTITY: {"description": "Validation Error", "model": ErrorResponse}
})
def registration(commons: Annotated[dict, Depends(registration)]):
    """
    Stores a new user.
    :return: the user if stored successfully
    """
    return commons


@router.patch('', response_model=UserResponse, responses={
    status.HTTP_404_NOT_FOUND: {"description": "User not found", "model": ErrorResponse},
    status.HTTP_400_BAD_REQUEST: {"description": "Validation Error", "model": ErrorResponse},
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


@router.get('/algo/{algo_id}', response_model=UserResponseWithInterestsAndDistance | None, responses={
    status.HTTP_404_NOT_FOUND: {"description": "Not Found", "model": ErrorResponse},
    status.HTTP_400_BAD_REQUEST: {"description": "Bad Request", "model": ErrorResponse},
})
def get_algo_user(commons: Annotated[User, Depends(get_algo_user)]):
    """
    Retrieves a user based on a given algorithm
        1: random
        3: decision-based
    :return: a user with a corresponding id which is in the search radius
    """
    return commons


@router.websocket("/socket/{user_token}")
async def socket(commons: Annotated[dict, Depends(websocket_connect)]):
    return commons


@router.get('/profile/{user_id}', responses={
    status.HTTP_404_NOT_FOUND: {"description": "Not Found", "model": ErrorResponse},
    status.HTTP_400_BAD_REQUEST: {"description": "Bad Request", "model": ErrorResponse},
})
def get_user_profile(commons: Annotated[dict, Depends(get_user_profile)]):
    """
    Retrieves a user.
    :return: a user with a corresponding id
    """
    return commons
