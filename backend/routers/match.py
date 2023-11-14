from typing import List, Annotated

from fastapi import APIRouter, HTTPException, Depends
from fastapi_pagination import Page, paginate
from starlette import status

from backend.exceptions.bad_request_exception import BadRequestException
from backend.exceptions.not_found_exception import NotFoundException
from backend.services.match import get_match, get_matches, post_match
from backend.models.match import Match

router = APIRouter(prefix='/matches', tags=['matches'], responses={status.HTTP_200_OK: {"description": "Success"}})


@router.get("/", response_model=Page[Match])
async def get_matches(commons: Annotated[dict, Depends(get_matches)]):
    """
    Get a paginated list of matches
    :return: a paginated list of matches
    """
    return paginate(commons)


@router.get('/{match_id}', response_model=Match)
def get_match(commons: Annotated[dict, Depends(get_match)]):
    """
    Return a specific match
    :return: a specific match
    """
    return commons


@router.post("/", response_model=Match)
def post_match(commons: Annotated[dict, Depends(post_match)]):
    """
    Create a match
    :return: a match object
    """
    return commons
