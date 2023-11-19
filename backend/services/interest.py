from typing import Annotated
from fastapi import Depends, HTTPException
from sqlmodel import Session, select

from backend.models.interest import Interest
from backend.repository.repository import create_session


def get_interests(db: Annotated[Session, Depends(create_session)]):
    """
    Return all interests
    :param db: injected database
    :return: a list of interests
    """
    return db.exec(select(Interest)).all()


def get_interest(interest_id, db: Annotated[Session, Depends(create_session)]):
    """
    Return a specific Interest
    :param interest_id: the id of the Interest
    :param db: injected database
    :return: an Interest object
    """
    interest = db.exec(select(Interest).where(Interest.id == interest_id)).first()
    if interest is None:
        raise HTTPException(status_code=404, detail=f"Could not find interest with id = {interest_id}")

    return interest


def post_interest(interest: Interest, db: Annotated[Session, Depends(create_session)]):
    """
    [endpoint to be deleted in production]
    Create an Interest
    :param interest: an interest object
    :param db: injected database
    :return: an interest object
    """
    db.add(interest)
    db.commit()
    db.refresh(interest)
    return interest
