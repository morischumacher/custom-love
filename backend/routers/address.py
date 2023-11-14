from typing import Annotated
from fastapi import APIRouter, Depends
from fastapi_pagination import Page, paginate
from starlette import status
from backend.responses.error_response import ErrorResponse
from backend.services.address import get_address, get_addresses, post_address
from backend.models.address import Address

router = APIRouter(prefix='/addresses', tags=['addresses'], responses={status.HTTP_200_OK: {"description": "Success"}})


@router.get('/', response_model=Page[Address])
async def get_addresses(commons: Annotated[dict, Depends(get_addresses)]):
    """
    [endpoint to be deleted in production]
    :return: paginated Addresses
    """
    return paginate(commons)


@router.get('/{address_id}', response_model=Address, responses={
    status.HTTP_404_NOT_FOUND: {"description": "Not Found", "model": ErrorResponse},
    status.HTTP_400_BAD_REQUEST: {"description": "Bad Request", "model": ErrorResponse},
})
async def get_address(commons: Annotated[dict, Depends(get_address)]):
    """
    [Authorization required]
    :return: an Address object
    """
    return commons


@router.post("/", response_model=Address, responses={
    status.HTTP_422_UNPROCESSABLE_ENTITY: {"description": "Validation Error", "model": ErrorResponse}
})
async def post_address(commons: Annotated[dict, Depends(post_address)]):
    """
    [Authorization required]
    :return: an Address object
    """
    return commons
