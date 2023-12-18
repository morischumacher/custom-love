import json
from typing import Any

from pydantic import BaseModel
from enum import Enum


class NotificationType(str, Enum):
    message: str = "message"


class Notification(BaseModel):
    type: NotificationType
    content: Any

    def __init__(self, _json: json):
        super().__init__(type=NotificationType[_json["type"]], content=_json["content"])
