from typing import TYPE_CHECKING, Optional, List

from sqlmodel import SQLModel, Field, Relationship

if TYPE_CHECKING:
    from .user import User


# TODO: Make country an enum
class Address(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    country: str
    city: str
    district: str
    latitude_northeast: float
    latitude_southwest: float
    longitude_northeast: float
    longitude_southwest: float

    users: List["User"] = Relationship(back_populates="address")
