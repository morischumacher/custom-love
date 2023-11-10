from typing import Annotated
from fastapi import Depends, HTTPException
from sqlmodel import Session, select

from backend.models.gender_identity import GenderIdentity
from backend.repository.repository import create_session


def get_gender_identities(db: Annotated[Session, Depends(create_session)]):
    return db.exec(select(GenderIdentity)).all()


def get_gender_identity(gender_identity_id, db: Annotated[Session, Depends(create_session)]):
    gender_identity = db.exec(select(GenderIdentity).where(GenderIdentity.id == gender_identity_id)).first()
    if gender_identity is None:
        raise HTTPException(status_code=404, detail=f"Could not find gender_identity with id = {gender_identity_id}")

    return gender_identity


def post_gender_identity(gender_identity: GenderIdentity, db: Annotated[Session, Depends(create_session)]):
    db.add(gender_identity)
    db.commit()
    db.refresh(gender_identity)
    return gender_identity
