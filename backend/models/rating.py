from typing import Optional, List, TYPE_CHECKING

from sqlmodel import SQLModel, Field, Relationship

if TYPE_CHECKING:
    from .user import User


class Rating(SQLModel, table=True):
    rating_user_id: Field(default=None, foreign_key="user.id")
    rated_user_id: Field(default=None, foreign_key="user.id")
    rating: int

    rating_user: User = Relationship(back_populates="ratings_given")
    rated_user: User = Relationship(back_populates="ratings_received")
