from typing import List

from fastapi import APIRouter
from sqlmodel import select, Session
from sqlmodel.sql.expression import SelectOfScalar
from starlette import status

from backend.models.preference import Preference
from backend.repository.repository import get_engine

router = APIRouter(prefix='/preference', tags=['preference'], responses={404: {"description": "Not found"}})


@router.get('/', tags=['get'])
async def get_preference():
    return {"language status": "alive"}


@router.get("/all", response_model=List[Preference], status_code=status.HTTP_200_OK)
async def get_preferences():
    with Session(get_engine()) as session:
        statement: SelectOfScalar[Preference] = select(Preference)
        preferences: List[Preference] = session.exec(statement).all()

    return preferences
