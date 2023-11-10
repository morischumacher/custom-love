from typing import Annotated
from fastapi import Depends, HTTPException
from sqlmodel import Session, select

from backend.models.rating import Rating
from backend.repository.repository import create_session


def get_ratings(db: Annotated[Session, Depends(create_session)]):
    return db.exec(select(Rating)).all()


def get_rating(rating_id, db: Annotated[Session, Depends(create_session)]):
    rating = db.exec(select(Rating).where(Rating.id == rating_id)).first()
    if rating is None:
        raise HTTPException(status_code=404, detail=f"Could not find rating with id = {rating_id}")

    return rating


def post_rating(rating: Rating, db: Annotated[Session, Depends(create_session)]):
    db.add(rating)
    db.commit()
    db.refresh(rating)
    return rating
