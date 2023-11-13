from typing import Optional, List, TYPE_CHECKING

from sqlmodel import SQLModel, Field, Relationship

from .connectors.user_has_interest import UserHasInterest

if TYPE_CHECKING:
    from .user import User


class Interest(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str
    icon: str

    users: List["User"] = Relationship(back_populates="interests", link_model=UserHasInterest)
