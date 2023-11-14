from typing import Annotated
from fastapi import Depends
from sqlmodel import Session, select
from sqlmodel.sql.expression import SelectOfScalar
from backend.exceptions.bad_request_exception import BadRequestException
from backend.exceptions.not_found_exception import NotFoundException
from backend.exceptions.validation_exception import ValidationException
from backend.models.address import Address
from backend.repository.repository import create_session


def get_addresses(db: Annotated[Session, Depends(create_session)]):
    """
    Return all the addresses from the db
    :param db: injected database
    :return: an Address object
    """
    statement: SelectOfScalar[Address] = select(Address)
    addresses: list[Address] = db.exec(statement).all()
    return addresses


def get_address(address_id: int, db: Annotated[Session, Depends(create_session)]):
    """
    Return the address with the given id
    :param address_id: id of the address
    :param db: injected database
    :return: an Address object
    """
    statement = select(Address).where(Address.id == address_id)
    address: list[Address] = db.exec(statement).all()
    if len(address) == 0:
        raise NotFoundException(f"Could not find addresses with id = {address_id}")
    elif len(address) > 1:
        raise BadRequestException(f"More than one address with id = {address_id} was found")
    return address[0]


def post_address(address: Address, db: Annotated[Session, Depends(create_session)]):
    """
    Create an address
    :param address: the address to be added
    :param db: injected database
    :return: an Address object (with the id)
    """
    if len(address.city) > 255:
        raise ValidationException("Name of the city is too long")

    db.add(address)
    db.commit()
    db.refresh(address)
    return address
