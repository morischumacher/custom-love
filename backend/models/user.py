from datetime import datetime
from typing import TYPE_CHECKING, Optional, List

from sqlmodel import SQLModel, Field, Relationship

from .connectors.user_has_language import UserHasLanguage
from .connectors.user_has_preference import UserHasPreference
from .connectors.user_has_interest import UserHasInterest

if TYPE_CHECKING:
    from .language import Language
    from .preference import Preference
    from .address import Address
    from .gender_identity import GenderIdentity
    from .interest import Interest

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

    gender_identity_id: Optional[int] = Field(default=None, foreign_key="gender_identity.id")
    address_id: Optional[int] = Field(default=None, foreign_key="address.id")

    gender_identity: Optional["GenderIdentity"] = Relationship(back_populates="users")
    address: Optional["Address"] = Relationship(back_populates="users")
    languages: Optional["Language"] = Relationship(back_populates="users", link_model=UserHasLanguage)
    preferences: Optional["Preference"] = Relationship(back_populates="users", link_model=UserHasPreference)
    interests: Optional["Interest"] = Relationship(back_populates="users", link_model=UserHasInterest)


