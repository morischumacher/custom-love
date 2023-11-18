import json
from datetime import datetime
from typing import TYPE_CHECKING, Optional, Any
from sqlmodel import SQLModel, Field, Relationship

if TYPE_CHECKING:
    from .user import User


class Message(SQLModel, table=True):
    id: Optional[int] = Field(primary_key=True)
    sender_id: Optional[int] = Field(default=None, foreign_key="user.id")
    receiver_id: Optional[int] = Field(default=None, foreign_key="user.id")
    message: str = Field(default=None)
    timestamp: Optional[datetime] = Field(default=datetime.now())

    ratings_given: "User" = Relationship(sa_relationship_kwargs={
        "primaryjoin": "Message.sender_id==User.id",
        "lazy": "joined",
    })

    ratings_received: "User" = Relationship(sa_relationship_kwargs={
        "primaryjoin": "Message.receiver_id==User.id",
        "lazy": "joined",
    })

    def __init__(self, _json: json, **data: Any):
        super().__init__(**data)
        self.sender_id = _json['sender_id']
        self.receiver_id = _json['receiver_id']
        self.message = _json['message']
