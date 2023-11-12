from typing import Annotated
from fastapi import Depends, HTTPException
from sqlmodel import Session, select

from backend.models.gender_preference import GenderPreference
from backend.repository.repository import create_session


def get_gender_preferences(db: Annotated[Session, Depends(create_session)]):
    return db.exec(select(GenderPreference)).all()


def get_gender_preference(gender_preference_id, db: Annotated[Session, Depends(create_session)]):
    gender_preference = db.exec(select(GenderPreference).where(GenderPreference.id == gender_preference_id)).first()
    if gender_preference is None:
        raise HTTPException(status_code=404, detail=f"Could not find gender preference with id = {gender_preference_id}")

    return gender_preference


def post_gender_preference(gender_preference: GenderPreference, db: Annotated[Session, Depends(create_session)]):
    db.add(gender_preference)
    db.commit()
    db.refresh(gender_preference)
    return gender_preference
