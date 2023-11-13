from typing import Annotated
from fastapi import Depends, HTTPException
from sqlmodel import Session, select

from backend.models.preference import Preference
from backend.repository.repository import create_session


def get_preferences(db: Annotated[Session, Depends(create_session)]):
    return db.exec(select(Preference)).all()


def get_preference(preference_id, db: Annotated[Session, Depends(create_session)]):
    preference = db.exec(select(Preference).where(Preference.id == preference_id)).first()
    if preference is None:
        raise HTTPException(status_code=404, detail=f"Could not find preference with id = {preference_id}")

    return preference


def post_preference(preference: Preference, db: Annotated[Session, Depends(create_session)]):
    db.add(preference)
    db.commit()
    db.refresh(preference)
    return preference
