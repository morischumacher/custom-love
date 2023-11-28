from pydantic import BaseModel, Field


class UserUpdate(BaseModel):
    latitude: float = Field(None, title="Latitude")
    longitude: float = Field(None, title="Longitude")
