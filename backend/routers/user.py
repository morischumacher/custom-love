from typing import Annotated, List

from fastapi import APIRouter, Depends
from sqlmodel import select, Session
from sqlmodel.sql.expression import SelectOfScalar
from starlette import status

from backend.models.language import Language
from backend.models.user import User
from backend.repository.repository import get_engine
from backend.services.user import get_user, post_user

router = APIRouter(prefix='/user', tags=['user'], responses={404: {"description": "Not found"}})


@router.get('/{user_id}', tags=['get'])
def get_user(commons: Annotated[dict, Depends(get_user)]):
    return commons


@router.post('/', tags=['post'])
def post_user(user: User, commons: Annotated[dict, Depends(post_user)]):
    return commons


@router.get("/all", response_model=List[User], status_code=status.HTTP_200_OK)
async def get_users():
    with Session(get_engine()) as session:
        statement: SelectOfScalar[User] = select(User)
        users: list[User] = session.exec(statement).all()

    return users
