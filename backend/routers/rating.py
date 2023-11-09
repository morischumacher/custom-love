from typing import List

from fastapi import APIRouter
from starlette import status

from backend import services
from backend.models.rating import Rating
from backend.services.rating import get_rating, get_ratings, post_rating


router = APIRouter(prefix='/ratings', tags=['ratings'], responses={404: {"description": "Not found"}})


@router.get("/", tags=['get'], response_model=List[Rating], status_code=status.HTTP_200_OK)
async def get_ratings():
    return services.rating.get_ratings()


@router.get('/{rating_id}', tags=['get'], status_code=status.HTTP_200_OK)
def get_rating(rating_id: int):
    return services.rating.get_rating(rating_id)


@router.post("/", tags=['post'], response_model=Rating, status_code=status.HTTP_200_OK)
def post_rating(rating: Rating):
    return services.rating.post_rating(rating)
