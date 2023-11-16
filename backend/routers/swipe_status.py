from typing import List, Annotated

from fastapi import APIRouter, HTTPException, Depends
from starlette import status

from backend.exceptions.fatal_exception import FatalException
from backend.exceptions.not_found_exception import NotFoundException
from backend.services.swipe_status import get_swipe_status, get_swipe_statuses
from backend.models.swipe_status import SwipeStatus

router = APIRouter(prefix='/swipe_statuses', tags=['swipe_statuses'], responses={404: {"description": "Not found"}})


@router.get('/{match_id}', tags=['get'])
def get_swipe_status(match_id: int, commons: Annotated[dict, Depends(get_swipe_status)]):
    try:
        return commons
    except NotFoundException as e:
        raise HTTPException(status_code=404, detail=e.message)
    except FatalException as e:
        raise HTTPException(status_code=400, detail=e.message)


@router.get("/", response_model=List[SwipeStatus], status_code=status.HTTP_200_OK)
async def get_swipe_statuses(commons: Annotated[dict, Depends(get_swipe_statuses)], user_id: int | None = None, is_match: bool | None = None):
    try:
        return commons
    except NotFoundException as e:
        raise HTTPException(status_code=404, detail=e.message)

