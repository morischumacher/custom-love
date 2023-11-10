from typing import List, Annotated

from fastapi import APIRouter, Depends
from starlette import status

from backend.models.rating import Rating
from backend.services.rating import get_rating, get_ratings, post_rating

router = APIRouter(prefix='/ratings', tags=['ratings'], responses={404: {"description": "Not found"}})


@router.get("/", response_model=List[Rating], status_code=status.HTTP_200_OK)
async def get_ratings(commons: Annotated[dict, Depends(get_ratings)]):
    return commons


@router.get('/{rating_id}', tags=['get'], response_model=Rating, status_code=status.HTTP_200_OK)
def get_rating(commons: Annotated[dict, Depends(get_rating)]):
    return commons


@router.post('/', tags=['post'], status_code=status.HTTP_200_OK)
def post_rating(rating: Rating, commons: Annotated[dict, Depends(post_rating)]):
    return commons
