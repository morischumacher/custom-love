from typing import List

from fastapi import APIRouter
from sqlmodel import select, Session
from sqlmodel.sql.expression import SelectOfScalar
from starlette import status

from backend.models.address import Address
from backend.repository.repository import get_engine

router = APIRouter(prefix='/address', tags=['address'], responses={404: {"description": "Not found"}})


@router.get('/', tags=['get'])
async def get_address():
    return {"address status": "alive"}


@router.get("/all", response_model=List[Address], status_code=status.HTTP_200_OK)
async def get_addresses():
    with Session(get_engine()) as session:
        statement: SelectOfScalar[Address] = select(Address)
        addresses: List[Address] = session.exec(statement).all()

    return addresses
