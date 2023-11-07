from datetime import datetime
from typing import TYPE_CHECKING, Optional, List

from sqlmodel import SQLModel, Field, Relationship

from backend.models.connectors.user_has_language import UserHasLanguage

if TYPE_CHECKING:
    from .language import Language


class User(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    first_name: str
    last_name: str
    email: str
    tel: str
    bio: str
    date_of_birth: datetime
    job: str
    search_radius: int
    swipes_left: int

    languages: Optional["Language"] = Relationship(back_populates="users", link_model=UserHasLanguage)

