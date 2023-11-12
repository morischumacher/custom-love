from typing import List, Annotated

from fastapi import APIRouter, Depends
from starlette import status

from backend.services.language import get_languages
from backend.models.language import Language

router = APIRouter(prefix='/languages', tags=['languages'], responses={404: {"description": "Not found"}})


@router.get("/", response_model=List[Language], status_code=status.HTTP_200_OK)
async def get_languages(commons: Annotated[dict, Depends(get_languages)]):
    return commons
