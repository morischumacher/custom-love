from typing import List

from fastapi import APIRouter, HTTPException
from starlette import status

from backend import services
from backend.models.preference import Preference
from backend.services.preference import get_preference, get_preferences, post_preference
from backend.exceptions import ValidationException
from backend.exceptions.FatalException import FatalException
from backend.exceptions.NotFoundException import NotFoundException

router = APIRouter(prefix='/preferences', tags=['preferences'], responses={404: {"description": "Not found"}})


@router.get("/", tags=['get'], response_model=List[Preference], status_code=status.HTTP_200_OK)
async def get_preferences():
    return services.preference.get_preferences()


@router.get('/{preference_id}', tags=['get'], status_code=status.HTTP_200_OK)
async def get_preference(preference_id: int):
    try:
        return services.preference.get_preference(preference_id)
    except NotFoundException as e:
        raise HTTPException(status_code=404, detail=e.message)
    except FatalException as e:
        raise HTTPException(status_code=400, detail=e.message)


@router.post("/", tags=['post'], response_model=Preference, status_code=status.HTTP_200_OK)
async def post_preference(preference: Preference):
    try:
        return services.preference.post_preference(preference)
    except ValidationException as e:
        raise HTTPException(status_code=422, detail=e.message)
