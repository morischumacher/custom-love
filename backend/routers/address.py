from typing import Annotated

from fastapi import APIRouter, HTTPException, Depends
from starlette import status

from backend.exceptions.fatal_exception import FatalException
from backend.exceptions.not_found_exception import NotFoundException
from backend.exceptions.validation_exception import ValidationException
from backend.services.address import get_address, get_addresses, post_address
from backend.models.address import Address

router = APIRouter(prefix='/addresses', tags=['addresses'], responses={404: {"description": "Not found"}})


@router.get('/', tags=['get'])
async def get_addresses(commons: Annotated[dict, Depends(get_addresses)]):
    return commons


@router.get('/{address_id}', tags=['get'])
async def get_address(commons: Annotated[dict, Depends(get_address)]):
    try:
        return commons
    except NotFoundException as e:
        raise HTTPException(status_code=404, detail=e.message)
    except FatalException as e:
        raise HTTPException(status_code=400, detail=e.message)


@router.post("/", response_model=Address, status_code=status.HTTP_200_OK)
async def post_address(commons: Annotated[dict, Depends(post_address)]):
    try:
        return commons
    except ValidationException as e:
        raise HTTPException(status_code=422, detail=e.message)
