from typing import Annotated
from fastapi import Depends
from sqlalchemy import select
from sqlmodel import Session
from starlette.websockets import WebSocket, WebSocketDisconnect

from backend.models.conversation import Conversation
from backend.models.message import Message
from backend.repository.repository import create_session
from backend.models.user import User
from backend.utils.connection_manager import ConnectionManager
from backend.utils.logger import Logger
from backend.utils.token import get_current_user

connection_manager = ConnectionManager()


def get_conversations(user: Annotated[User, Depends(get_current_user)],
                      db: Annotated[Session, Depends(create_session)]):
    return db.exec(select(Conversation).
                   where(Conversation.user1_id == user.id or Conversation.user2_id == user.id))


def post_conversation(user_id: int, user: Annotated[User, Depends(get_current_user)],
                      db: Annotated[Session, Depends(create_session)]):
    conversation: Conversation = Conversation(user1_id=user.id, user2_id=user_id)
    db.add(conversation)
    db.refresh(conversation)
    db.commit()

    return conversation
