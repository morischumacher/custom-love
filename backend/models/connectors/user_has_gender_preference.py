from typing import Optional

from sqlmodel import SQLModel, Field


class UserHasGenderPreference(SQLModel, table=True):
    user_id: Optional[int] = Field(
        default=None, foreign_key="user.id", primary_key=True
    )
    gender_preference_id: Optional[int] = Field(
        default=None, foreign_key="gender_preference.id", primary_key=True
    )
