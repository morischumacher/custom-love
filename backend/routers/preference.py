from typing import List, Annotated

from fastapi import APIRouter, Depends
from starlette import status

from backend.models.preference import Preference
from backend.services.preference import get_preference, get_preferences, post_preference

router = APIRouter(prefix='/preferences', tags=['preferences'], responses={404: {"description": "Not found"}})


@router.get("/", response_model=List[Preference], status_code=status.HTTP_200_OK)
async def get_preferences(commons: Annotated[dict, Depends(get_preferences)]):
    return commons


@router.get('/{preference_id}', tags=['get'], response_model=Preference, status_code=status.HTTP_200_OK)
def get_preference(commons: Annotated[dict, Depends(get_preference)]):
    return commons


@router.post('/', tags=['post'], status_code=status.HTTP_200_OK)
def post_preference(preference: Preference, commons: Annotated[dict, Depends(post_preference)]):
    return commons
