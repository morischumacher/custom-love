from sqlmodel import Session, select
from sqlmodel.sql.expression import SelectOfScalar

from backend.exceptions.fatal_exception import FatalException
from backend.exceptions.not_found_exception import NotFoundException
from backend.repository.repository import get_engine
from backend.models.interest import Interest


def get_interest(interest_id: int):
    with Session(get_engine()) as session:
        statement = select(Interest).where(Interest.id == interest_id)
        interest: list[Interest] = session.exec(statement).all()
        if len(interest) == 0:
            raise NotFoundException(f"Could not find users with id = {interest_id}")
        elif len(interest) > 1:
            raise FatalException(f"More than one user for id = {interest_id} was found")
    return interest


def get_interests():
    with Session(get_engine()) as session:
        statement: SelectOfScalar[Interest] = select(Interest)
        interests: list[Interest] = session.exec(statement).all()
    return interests


def post_interest(interest: Interest):
    with Session(get_engine()) as session:
        session.add(interest)
        session.commit()
        session.refresh(interest)
    return interest
