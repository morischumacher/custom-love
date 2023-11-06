from typing import Annotated

from fastapi import APIRouter, Depends

from backend.models.user import User
from backend.services.user import get_user, post_user

router = APIRouter(prefix='/user', tags=['user'], responses={404: {"description": "Not found"}})


@router.get('/{user_id}', tags=['get'])
def get_user(commons: Annotated[dict, Depends(get_user)]):
    return commons


@router.post('/', tags=['post'])
def post_user(user: User, commons: Annotated[dict, Depends(post_user)]):
    return commons
