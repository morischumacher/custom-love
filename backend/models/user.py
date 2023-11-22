from datetime import datetime
from typing import TYPE_CHECKING, Optional, List

from sqlmodel import SQLModel, Field, Relationship

from .connectors.user_has_language import UserHasLanguage
from .connectors.user_has_gender_preference import UserHasGenderPreference
from .connectors.user_has_interest import UserHasInterest
from .connectors.user_has_preference import UserHasPreference

if TYPE_CHECKING:
    from .language import Language
    from .gender_identity import GenderIdentity
    from .interest import Interest
    from .preference import Preference


class User(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    first_name: str
    last_name: str
    email: str
    password: str
    bio: str
    date_of_birth: datetime
    job: str
    search_radius: int
    swipes_left: int
    latitude: Optional[float]
    longitude: Optional[float]
    location: Optional[str]

    gender_identity_id: Optional[int] = Field(default=None, foreign_key="gender_identity.id")

    gender_identity: Optional["GenderIdentity"] = Relationship(back_populates="user_gender_identity")
    languages: Optional["Language"] = Relationship(back_populates="users", link_model=UserHasLanguage)
    gender_preferences: Optional["GenderIdentity"] = Relationship(back_populates="users", link_model=UserHasGenderPreference)
    interests: Optional["Interest"] = Relationship(back_populates="users", link_model=UserHasInterest)
    preferences: Optional["Preference"] = Relationship(back_populates="users", link_model=UserHasPreference)
