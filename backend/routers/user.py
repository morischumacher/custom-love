import traceback
from typing import Annotated, List

from fastapi import APIRouter, Depends, HTTPException
from starlette import status

from backend import services
from backend.exceptions.FatalException import FatalException
from backend.exceptions.NotFoundException import NotFoundException
from backend.models.user import User
from backend.services.user import get_user, post_user

router = APIRouter(prefix='/users', tags=['users'], responses={404: {"description": "Not found"}})


@router.get("/", response_model=List[User], status_code=status.HTTP_200_OK)
async def get_users():
    return services.user.get_users()


@router.get('/{user_id}', tags=['get'])
def get_user(user_id: int):
    try:
        return services.user.get_user(user_id)
    except NotFoundException as e:
        raise HTTPException(status_code=404, detail=e.message)
    except FatalException as e:
        raise HTTPException(status_code=40, detail=e.message)


@router.post('/', tags=['post'])
def post_user(user: User, commons: Annotated[dict, Depends(post_user)]):
    return commons
