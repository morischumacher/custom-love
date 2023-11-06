from typing import Annotated
from fastapi import Depends
from sqlmodel import Session, select
from backend.repository.repository import create_session
from backend.models.user import User


def get_user(user_id, db: Annotated[Session, Depends(create_session)]):
    return db.exec(select(User)).all()


def post_user(user: User, db: Annotated[Session, Depends(create_session)]):
    db.add(user)
    db.commit()
    db.refresh(user)
    return user
