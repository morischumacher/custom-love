from typing import Annotated
from fastapi import Depends
from sqlmodel import Session, select
from sqlmodel.sql.expression import SelectOfScalar

from backend.exceptions.FatalException import FatalException
from backend.exceptions.NotFoundException import NotFoundException
from backend.exceptions.ValidationException import ValidationException
from backend.models.address import Address
from backend.repository.repository import get_engine


def get_address(address_id: int):
    with Session(get_engine()) as session:
        statement = select(Address).where(Address.id == address_id)
        address: list[Address] = session.exec(statement).all()
        if len(address) == 0:
            raise NotFoundException(f"Could not find addresses with id = {address_id}")
        elif len(address) > 1:
            raise FatalException(f"More than one address with id = {address_id} was found")
    return address


def get_addresses():
    with Session(get_engine()) as session:
        statement: SelectOfScalar[Address] = select(Address)
        users: list[Address] = session.exec(statement).all()
    return users


def post_address(address: Address):
    if len(address.city) > 255:
        raise ValidationException("Name of the city is too long")

    with Session(get_engine()) as session:
        session.add(address)
        session.commit()
        session.refresh(address)
    return address
