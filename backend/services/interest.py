from typing import Annotated
from fastapi import Depends, HTTPException
from sqlmodel import Session, select

from backend.models.interest import Interest
from backend.repository.repository import create_session


def get_interests(db: Annotated[Session, Depends(create_session)]):
    return db.exec(select(Interest)).all()


def get_interest(interest_id, db: Annotated[Session, Depends(create_session)]):
    interest = db.exec(select(Interest).where(Interest.id == interest_id)).first()
    if interest is None:
        raise HTTPException(status_code=404, detail=f"Could not find interest with id = {interest_id}")

    return interest


def post_interest(interest: Interest, db: Annotated[Session, Depends(create_session)]):
    db.add(interest)
    db.commit()
    db.refresh(interest)
    return interest
