from typing import List

from fastapi import APIRouter
from starlette import status

from backend import services
from backend.services.language import get_languages
from backend.models.language import Language

router = APIRouter(prefix='/languages', tags=['languages'], responses={404: {"description": "Not found"}})


@router.get("/", response_model=List[Language], status_code=status.HTTP_200_OK)
async def get_languages():
    return services.language.get_languages()
