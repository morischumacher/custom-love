from typing import List, Annotated

from fastapi import APIRouter, Depends
from sqlmodel import select, Session
from sqlmodel.sql.expression import SelectOfScalar
from starlette import status

from backend.models.interest import Interest
from backend.repository.repository import get_engine

router = APIRouter(prefix='/interest', tags=['interest'], responses={404: {"description": "Not found"}})


@router.get('/', tags=['get'])
async def get_interest():
    return {"interest status": "alive"}


@router.get('/{interest_id}', tags=['get'])
def get_interest(commons: Annotated[dict, Depends(get_interest)]):
    return commons


@router.get("/all", response_model=List[Interest], status_code=status.HTTP_200_OK)
async def get_interests():
    with Session(get_engine()) as session:
        statement: SelectOfScalar[Interest] = select(Interest)
        interests: List[Interest] = session.exec(statement).all()

    return interests
