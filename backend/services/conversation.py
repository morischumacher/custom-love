from typing import Annotated
from fastapi import Depends
from fastapi_pagination import Params
from fastapi_pagination.ext.sqlmodel import paginate
from sqlmodel import select, or_
from sqlmodel import Session
from starlette.requests import Request
from backend.models.conversation import Conversation
from backend.repository.repository import create_session
from backend.models.user import User
from backend.utils.token import get_current_user


def get_conversations(user: Annotated[User, Depends(get_current_user)],
                      db: Annotated[Session, Depends(create_session)], request: Request):
    return paginate(db, select(Conversation).where(or_(Conversation.user1_id == user.id,
                                                       Conversation.user2_id == user.id)),
                    Params(size=request.query_params.get("size"), page=request.query_params.get("page")))


def post_conversation(user_id: int, user: Annotated[User, Depends(get_current_user)],
                      db: Annotated[Session, Depends(create_session)]):
    conversation: Conversation = Conversation(user1_id=user.id, user2_id=user_id)
    db.add(conversation)
    db.refresh(conversation)
    db.commit()

    return conversation
