from typing import List, Annotated

from fastapi import APIRouter, Depends
from fastapi_pagination import Page
from starlette import status

from backend.responses.error_response import ErrorResponse
from backend.services.swipe_status import get_swipe_status, get_swipe_statuses, post_view, post_like, get_matches
from backend.models.swipe_status import SwipeStatus

router = APIRouter(prefix='/swipe_statuses', tags=['swipe_statuses'], responses={404: {"description": "Not found"}})


@router.get('/all/{match_id}', tags=['get'], response_model=Page[SwipeStatus], responses={
    status.HTTP_401_UNAUTHORIZED: {"description": "Error: Unauthorized", "model": ErrorResponse}
})
def get_swipe_status(match_id: int, commons: Annotated[dict, Depends(get_swipe_status)]):
    return commons


@router.get("/", response_model=List[SwipeStatus], status_code=status.HTTP_200_OK, responses={
    status.HTTP_401_UNAUTHORIZED: {"description": "Error: Unauthorized", "model": ErrorResponse}
})
async def get_swipe_statuses(commons: Annotated[dict, Depends(get_swipe_statuses)], user_id: int | None = None, is_match: bool | None = None):
    return commons


@router.get("/matches", response_model=List[SwipeStatus], status_code=status.HTTP_200_OK, responses={
    status.HTTP_401_UNAUTHORIZED: {"description": "Error: Unauthorized", "model": ErrorResponse}
})
async def get_matches(commons: Annotated[dict, Depends(get_matches)]):
    return commons


@router.post('/view/{user_id}', tags=['post'], response_model=SwipeStatus, responses={
    status.HTTP_401_UNAUTHORIZED: {"description": "Error: Unauthorized", "model": ErrorResponse}
})
async def post_swipe_status_view(commons: Annotated[dict, Depends(post_view)]):
    return commons


@router.post('/like/{user_id}', tags=['post'], response_model=SwipeStatus, responses={
    status.HTTP_401_UNAUTHORIZED: {"description": "Error: Unauthorized", "model": ErrorResponse}
})
async def post_like_status_like(commons: Annotated[dict, Depends(post_like)]):
    return commons
