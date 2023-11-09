from typing import List, Annotated

from fastapi import APIRouter, Depends
from sqlmodel import select, Session
from sqlmodel.sql.expression import SelectOfScalar
from starlette import status

from backend.models.match import Match
from backend.repository.repository import get_engine

router = APIRouter(prefix='/match', tags=['match'], responses={404: {"description": "Not found"}})


@router.get('/', tags=['get'])
async def get_match():
    return {"language status": "alive"}


@router.get('/{match_id}', tags=['get'])
def get_match(commons: Annotated[dict, Depends(get_match)]):
    return commons


@router.get("/all", response_model=List[Match], status_code=status.HTTP_200_OK)
async def get_match():
    with Session(get_engine()) as session:
        statement: SelectOfScalar[Match] = select(Match)
        matches: List[Match] = session.exec(statement).all()

    return matches
