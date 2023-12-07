from datetime import datetime
from typing import Optional

from pydantic import BaseModel

from backend.models.interest import Interest


class UserResponse(BaseModel):
    id: Optional[int] = None
    first_name: str
    last_name: str
    email: str
    bio: str
    date_of_birth: datetime
    job: str
    search_radius: int
    swipes_left: int
    latitude: Optional[float]
    longitude: Optional[float]
    gender_identity_id: Optional[int] = None
    interests: Optional[list[Interest]]
