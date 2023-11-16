from typing import Annotated
from fastapi import Depends, HTTPException
from sqlmodel import Session, select

from backend.models.rating import Rating
from backend.repository.repository import create_session


def get_ratings(db: Annotated[Session, Depends(create_session)]):
    """
    Return a list of all ratings
    :param db: injected database
    :return: a list of all ratings
    """
    return db.exec(select(Rating)).all()


def get_rating(rating_id, db: Annotated[Session, Depends(create_session)]):
    """
    Return a specific rating
    :param rating_id: the id of the rating
    :param db: injected database
    :return: a rating object
    """
    rating = db.exec(select(Rating).where(Rating.id == rating_id)).first()
    if rating is None:
        raise HTTPException(status_code=404, detail=f"Could not find rating with id = {rating_id}")

    return rating


def post_rating(rating: Rating, db: Annotated[Session, Depends(create_session)]):
    """
    Create a rating object
    :param rating: the rating object
    :param db: injected database
    :return: a rating object
    """
    db.add(rating)
    db.commit()
    db.refresh(rating)
    return rating
