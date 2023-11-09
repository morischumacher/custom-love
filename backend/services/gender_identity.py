from sqlmodel import Session, select
from sqlmodel.sql.expression import SelectOfScalar

from backend.exceptions.FatalException import FatalException
from backend.exceptions.NotFoundException import NotFoundException
from backend.repository.repository import get_engine
from backend.models.gender_identity import GenderIdentity


def get_gender_identity(gender_identity_id: int):
    with Session(get_engine()) as session:
        statement = select(GenderIdentity).where(GenderIdentity.id == gender_identity_id)
        gender_identity: list[GenderIdentity] = session.exec(statement).all()
        if len(gender_identity) == 0:
            raise NotFoundException(f"Could not find users with id = {gender_identity_id}")
        elif len(gender_identity) > 1:
            raise FatalException(f"More than one user for id = {gender_identity_id} was found")
    return gender_identity


def get_gender_identities():
    with Session(get_engine()) as session:
        statement: SelectOfScalar[GenderIdentity] = select(GenderIdentity)
        gender_identities: list[GenderIdentity] = session.exec(statement).all()
    return gender_identities


def post_gender_identity(gender_identity: GenderIdentity):
    with Session(get_engine()) as session:
        session.add(gender_identity)
        session.commit()
        session.refresh(gender_identity)
    return gender_identity
