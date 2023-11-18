import json
from datetime import datetime
from typing import Optional, Any
from typing import TYPE_CHECKING
from sqlmodel import SQLModel, Field, Relationship
from .conversation import Conversation


class Message(SQLModel, table=True):
    id: Optional[int] = Field(primary_key=True)
    conversation_id: int = Field(foreign_key="conversation.id")
    sender_id: int = Field(foreign_key="user.id")
    receiver_id: int = Field(foreign_key="user.id")
    message: str = Field(default=None)
    timestamp: Optional[datetime] = Field(default=datetime.now())

    conversation: Conversation = Relationship(sa_relationship_kwargs={
        "primaryjoin": "Message.conversation_id==Conversation.id",
        "lazy": "joined",
    })

    def __init__(self, _json: json, **data: Any):
        super().__init__(**data)
        self.conversation_id = _json['conversation_id']
        self.sender_id = _json['sender_id']
        self.receiver_id = _json['receiver_id']
        self.message = _json['message']
