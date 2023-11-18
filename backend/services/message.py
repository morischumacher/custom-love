from typing import Annotated
from fastapi import Depends
from sqlmodel import Session
from starlette.websockets import WebSocket, WebSocketDisconnect
from backend.models.message import Message
from backend.repository.repository import create_session
from backend.models.user import User
from backend.utils.connection_manager import ConnectionManager
from backend.utils.token import get_current_user

connection_manager = ConnectionManager()


async def websocket_connect(websocket: WebSocket, user_token: str, db: Annotated[Session, Depends(create_session)]):
    user: User = get_current_user(user_token, db)
    await connection_manager.connect(websocket, user.id)
    try:
        while True:
            data: Message = Message(await websocket.receive_json())
            await connection_manager.send_message(data.receiver_id, data)
    except WebSocketDisconnect:
        connection_manager.disconnect(websocket, user.id)
