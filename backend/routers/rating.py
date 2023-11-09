from typing import List, Annotated

from fastapi import APIRouter, Depends
from sqlmodel import select, Session
from sqlmodel.sql.expression import SelectOfScalar
from starlette import status

from backend.models.rating import Rating
from backend.repository.repository import get_engine

router = APIRouter(prefix='/rating', tags=['rating'], responses={404: {"description": "Not found"}})

@router.get('/', tags=['get'])
async def get_rating():
    return {"rating status": "alive"}


@router.get('/{rating_id}', tags=['get'])
def get_rating(commons: Annotated[dict, Depends(get_rating)]):
    return commons


@router.get("/all", response_model=List[Rating], status_code=status.HTTP_200_OK)
async def get_ratings():
    with Session(get_engine()) as session:
        statement: SelectOfScalar[Rating] = select(Rating)
        ratings: List[Rating] = session.exec(statement).all()

    return ratings
