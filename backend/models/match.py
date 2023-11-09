from typing import TYPE_CHECKING, Optional

from sqlmodel import SQLModel, Field, Relationship

if TYPE_CHECKING:
    from .user import User


class Match(SQLModel, table=True):
    id: Optional[int] = Field(primary_key=True)
    match_user1_id: Optional[int] = Field(default=None, foreign_key="user.id")
    match_user2_id: Optional[int] = Field(default=None, foreign_key="user.id")
    is_match: bool

    match_user1: "User" = Relationship(sa_relationship_kwargs={
        "primaryjoin": "Match.match_user1_id==User.id",
        "lazy": "joined",
    })

    match_user2: "User" = Relationship(sa_relationship_kwargs={
        "primaryjoin": "Match.match_user2_id==User.id",
        "lazy": "joined",
    })