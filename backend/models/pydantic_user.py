from datetime import datetime
from typing import Optional, Tuple
from pydantic import BaseModel

class UserBase(BaseModel):
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
