from sqlmodel import Session, select
from sqlmodel.sql.expression import SelectOfScalar

from backend.exceptions.fatal_exception import FatalException
from backend.exceptions.not_found_exception import NotFoundException
from backend.exceptions.validation_exception import ValidationException
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
        addresses: list[Address] = session.exec(statement).all()
    return addresses


def post_address(address: Address):
    if len(address.city) > 255:
        raise ValidationException("Name of the city is too long")

    with Session(get_engine()) as session:
        session.add(address)
        session.commit()
        session.refresh(address)
    return address
