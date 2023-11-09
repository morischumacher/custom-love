from typing import List

from fastapi import APIRouter
from starlette import status

from backend import services
from backend.models.preference import Preference
from backend.services.preference import get_preference, get_preferences, post_preference

router = APIRouter(prefix='/preferences', tags=['preferences'], responses={404: {"description": "Not found"}})


@router.get("/", tags=['get'], response_model=List[Preference], status_code=status.HTTP_200_OK)
async def get_preferences():
    return services.preference.get_preferences()


@router.get('/{preference_id}', tags=['get'], status_code=status.HTTP_200_OK)
def get_preference(preference_id: int):
    return services.preference.get_preference(preference_id)


@router.post("/", tags=['post'], response_model=Preference, status_code=status.HTTP_200_OK)
def post_preference(preference: Preference):
    return services.preference.post_preference(preference)

