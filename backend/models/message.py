import json
from datetime import datetime
from typing import Optional, Any
from typing import TYPE_CHECKING
from sqlmodel import SQLModel, Field, Relationship
from .conversation import Conversation
from .user import User


class Message(SQLModel, table=True):
    id: Optional[int] = Field(primary_key=True)
    conversation_id: int = Field(foreign_key="conversation.id")
    sender_id: int = Field(foreign_key="user.id")
    receiver_id: int = Field(foreign_key="user.id")
    message: str = Field(default=None)
    timestamp: Optional[datetime] = Field(default=None)

    conversation: Conversation = Relationship(sa_relationship_kwargs={
        "primaryjoin": "Message.conversation_id==Conversation.id",
        "lazy": "joined",
    })

    sender: User = Relationship(sa_relationship_kwargs={
        "primaryjoin": "Message.sender_id==User.id",
        "lazy": "joined",
    })

    receiver: User = Relationship(sa_relationship_kwargs={
        "primaryjoin": "Message.receiver_id==User.id",
        "lazy": "joined",
    })


def message_factory(_json: json):
    return Message(
        conversation_id=int(_json['conversation_id']),
        sender_id=_json['sender_id'],
        receiver_id=_json['receiver_id'],
        message=_json['message'],
        timestamp=datetime.now()
    )
