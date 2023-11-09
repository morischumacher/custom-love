from typing import List, Annotated

from fastapi import APIRouter, Depends
from sqlmodel import select, Session
from sqlmodel.sql.expression import SelectOfScalar
from starlette import status

from backend.models.language import Language
from backend.repository.repository import get_engine

router = APIRouter(prefix='/language', tags=['language'], responses={404: {"description": "Not found"}})


@router.get('/', tags=['get'])
async def get_language():
    return {"language status": "alive"}


@router.get('/{language_id}', tags=['get'])
def get_language(commons: Annotated[dict, Depends(get_language)]):
    return commons


@router.get("/all", response_model=List[Language], status_code=status.HTTP_200_OK)
async def get_languages():
    with Session(get_engine()) as session:
        statement: SelectOfScalar[Language] = select(Language)
        languages: List[Language] = session.exec(statement).all()

    return languages
