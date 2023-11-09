from typing import List

from fastapi import APIRouter, HTTPException
from starlette import status

from backend import services
from backend.models.rating import Rating
from backend.services.rating import get_rating, get_ratings, post_rating
from backend.exceptions import ValidationException
from backend.exceptions.FatalException import FatalException
from backend.exceptions.NotFoundException import NotFoundException

router = APIRouter(prefix='/ratings', tags=['ratings'], responses={404: {"description": "Not found"}})


@router.get("/", tags=['get'], response_model=List[Rating], status_code=status.HTTP_200_OK)
async def get_ratings():
    return services.rating.get_ratings()


@router.get('/{rating_id}', tags=['get'], status_code=status.HTTP_200_OK)
async def get_rating(rating_id: int):
    try:
        return services.rating.get_rating(rating_id)
    except NotFoundException as e:
        raise HTTPException(status_code=404, detail=e.message)
    except FatalException as e:
        raise HTTPException(status_code=400, detail=e.message)


@router.post("/", tags=['post'], response_model=Rating, status_code=status.HTTP_200_OK)
async def post_rating(rating: Rating):
    try:
        return services.rating.post_rating(rating)
    except ValidationException as e:
        raise HTTPException(status_code=422, detail=e.message)
