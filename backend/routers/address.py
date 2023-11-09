from fastapi import APIRouter, HTTPException
from starlette import status

from backend import services
from backend.exceptions import ValidationException
from backend.exceptions.FatalException import FatalException
from backend.exceptions.NotFoundException import NotFoundException
from backend.services.address import get_address
from backend.models.address import Address

router = APIRouter(prefix='/addresses', tags=['addresses'], responses={404: {"description": "Not found"}})


@router.get('/', tags=['get'])
async def get_addresses():
    return services.address.get_addresses()


@router.get('/{address_id}', tags=['get'])
async def get_address(address_id: int):
    try:
        return services.address.get_address(address_id)
    except NotFoundException as e:
        raise HTTPException(status_code=404, detail=e.message)
    except FatalException as e:
        raise HTTPException(status_code=400, detail=e.message)


@router.post("/", response_model=Address, status_code=status.HTTP_200_OK)
async def post_address(address: Address):
    try:
        return services.address.post_address(address)
    except ValidationException as e:
        raise HTTPException(status_code=422, detail=e.message)
