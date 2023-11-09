from typing import List

from fastapi import APIRouter, HTTPException
from starlette import status

from backend import services
from backend.models.interest import Interest
from backend.services.interest import get_interest, get_interests, post_interest
from backend.exceptions import ValidationException
from backend.exceptions.FatalException import FatalException
from backend.exceptions.NotFoundException import NotFoundException

router = APIRouter(prefix='/interests', tags=['interests'], responses={404: {"description": "Not found"}})


@router.get("/", tags=['get'], response_model=List[Interest], status_code=status.HTTP_200_OK)
async def get_interests():
    return services.interest.get_interests()


@router.get('/{interest_id}', tags=['get'], status_code=status.HTTP_200_OK)
async def get_interest(interest_id: int):
    try:
        return services.interest.get_interest(interest_id)
    except NotFoundException as e:
        raise HTTPException(status_code=404, detail=e.message)
    except FatalException as e:
        raise HTTPException(status_code=400, detail=e.message)


@router.post("/", tags=['post'], response_model=Interest, status_code=status.HTTP_200_OK)
async def post_interest(interest: Interest):
    try:
        return services.interest.post_interest(interest)
    except ValidationException as e:
        raise HTTPException(status_code=422, detail=e.message)
