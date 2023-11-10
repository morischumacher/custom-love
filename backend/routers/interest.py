from typing import List, Annotated

from fastapi import APIRouter, Depends
from starlette import status

from backend.models.interest import Interest
from backend.services.interest import get_interest, get_interests, post_interest

router = APIRouter(prefix='/interests', tags=['interests'], responses={404: {"description": "Not found"}})


@router.get("/", response_model=List[Interest], status_code=status.HTTP_200_OK)
async def get_interests(commons: Annotated[dict, Depends(get_interests)]):
    return commons


@router.get('/{interest_id}', tags=['get'], response_model=Interest, status_code=status.HTTP_200_OK)
def get_interest(commons: Annotated[dict, Depends(get_interest)]):
    return commons


@router.post('/', tags=['post'], status_code=status.HTTP_200_OK)
def post_interest(interest: Interest, commons: Annotated[dict, Depends(post_interest)]):
    return commons
