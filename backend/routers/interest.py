from typing import List

from fastapi import APIRouter
from starlette import status

from backend import services
from backend.models.interest import Interest
from backend.services.interest import get_interest, get_interests, post_interest


router = APIRouter(prefix='/interests', tags=['interests'], responses={404: {"description": "Not found"}})


@router.get("/", tags=['get'], response_model=List[Interest], status_code=status.HTTP_200_OK)
async def get_interests():
    return services.interest.get_interests()


@router.get('/{interest_id}', tags=['get'], status_code=status.HTTP_200_OK)
def get_interest(interest_id: int):
    return services.interest.get_interest(interest_id)


@router.post("/", tags=['post'], response_model=Interest, status_code=status.HTTP_200_OK)
def post_interest(interest: Interest):
    return services.interest.post_interest(interest)
