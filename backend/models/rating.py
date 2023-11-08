from typing import TYPE_CHECKING, Optional

from sqlmodel import SQLModel, Field, Relationship

if TYPE_CHECKING:
    from .user import User


# class Rating(SQLModel, table=True):
class Rating:
    rating_user_id: Optional[int] = Field(default=None, foreign_key="user.id", primary_key=True)
    rated_user_id: Optional[int] = Field(default=None, foreign_key="user.id", primary_key=True)
    rating: int

    rating_user: "User" = Relationship(back_populates="ratings_given")
    rated_user: "User" = Relationship(back_populates="ratings_received")
