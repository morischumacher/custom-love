from sqlmodel import Session, select
from sqlmodel.sql.expression import SelectOfScalar

from backend.exceptions.FatalException import FatalException
from backend.exceptions.NotFoundException import NotFoundException
from backend.repository.repository import get_engine
from backend.models.rating import Rating


def get_rating(rating_id: int):
    with Session(get_engine()) as session:
        statement = select(Rating).where(Rating.id == rating_id)
        rating: list[Rating] = session.exec(statement).all()
        if len(rating) == 0:
            raise NotFoundException(f"Could not find users with id = {rating_id}")
        elif len(rating) > 1:
            raise FatalException(f"More than one user for id = {rating_id} was found")
    return rating


def get_ratings():
    with Session(get_engine()) as session:
        statement: SelectOfScalar[Rating] = select(Rating)
        ratings: list[Rating] = session.exec(statement).all()
    return ratings


def post_rating(rating: Rating):
    with Session(get_engine()) as session:
        session.add(rating)
        session.commit()
        session.refresh(rating)
    return rating
