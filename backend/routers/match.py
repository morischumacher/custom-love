from typing import List, Annotated

from fastapi import APIRouter, HTTPException, Depends
from starlette import status

from backend.exceptions.fatal_exception import FatalException
from backend.exceptions.not_found_exception import NotFoundException
from backend.services.match import get_match, get_matches
from backend.models.match import Match

router = APIRouter(prefix='/matches', tags=['matches'], responses={404: {"description": "Not found"}})


@router.get('/{match_id}', tags=['get'])
def get_match(match_id: int, commons: Annotated[dict, Depends(get_match)]):
    try:
        return commons
    except NotFoundException as e:
        raise HTTPException(status_code=404, detail=e.message)
    except FatalException as e:
        raise HTTPException(status_code=400, detail=e.message)


@router.get("/", response_model=List[Match], status_code=status.HTTP_200_OK)
async def get_matches(commons: Annotated[dict, Depends(get_matches)], user_id: int | None = None, is_match: bool | None = None):
    try:
        return commons
    except NotFoundException as e:
        raise HTTPException(status_code=404, detail=e.message)

