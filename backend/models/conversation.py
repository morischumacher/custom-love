from typing import Optional
from sqlmodel import SQLModel, Field, Relationship


class Conversation(SQLModel, table=True):
    id: Optional[int] = Field(primary_key=True)
    user1_id: int = Field(foreign_key="user.id")
    user2_id: int = Field(foreign_key="user.id")
