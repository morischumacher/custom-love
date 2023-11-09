from typing import List

from fastapi import APIRouter, HTTPException
from starlette import status

from backend import services
from backend.exceptions.fatal_exception import FatalException
from backend.exceptions.not_found_exception import NotFoundException
from backend.services.match import get_match
from backend.models.match import Match

router = APIRouter(prefix='/matches', tags=['matches'], responses={404: {"description": "Not found"}})


@router.get('/{match_id}', tags=['get'])
def get_match(match_id: int):
    try:
        return services.match.get_match(match_id)
    except NotFoundException as e:
        raise HTTPException(status_code=404, detail=e.message)
    except FatalException as e:
        raise HTTPException(status_code=400, detail=e.message)


@router.get("/", response_model=List[Match], status_code=status.HTTP_200_OK)
async def get_matches(user_id: int | None = None, is_match: bool | None = None):
    if user_id is None:
        print("HERE")
        print("HERE")
        print("HERE")
        return services.match.get_matches(is_match)
    else:
        try:
            print("TMP")
            print("TMP")
            print("TMP")
            return services.match.get_all_user_matches(user_id, is_match)
        except NotFoundException as e:
            raise HTTPException(status_code=404, detail=e.message)

