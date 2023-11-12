from typing import List, Annotated

from fastapi import APIRouter, Depends
from starlette import status

from backend.models.gender_preference import GenderPreference
from backend.services.gender_preference import get_gender_preference, get_gender_preferences, post_gender_preference

router = APIRouter(prefix='/gender-preferences', tags=['gender-preferences'], responses={404: {"description": "Not found"}})


@router.get("/", response_model=List[GenderPreference], status_code=status.HTTP_200_OK)
async def get_gender_preferences(commons: Annotated[dict, Depends(get_gender_preferences)]):
    return commons


@router.get('/{gender_preference_id}', tags=['get'], response_model=GenderPreference, status_code=status.HTTP_200_OK)
def get_preference(commons: Annotated[dict, Depends(get_gender_preference)]):
    return commons


@router.post('/', tags=['post'], status_code=status.HTTP_200_OK)
def post_gender_preference(gender_preference: GenderPreference, commons: Annotated[dict, Depends(post_gender_preference)]):
    return commons
