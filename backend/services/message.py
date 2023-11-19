from typing import Annotated
from fastapi import Depends
from sqlmodel import Session, select, col
from starlette.websockets import WebSocket, WebSocketDisconnect

from backend.exceptions.credentials_exception import CredentialsException
from backend.models.conversation import Conversation
from backend.models.message import Message
from backend.repository.repository import create_session
from backend.models.user import User
from backend.utils.connection_manager import ConnectionManager
from backend.utils.logger import Logger
from backend.utils.token import get_current_user

connection_manager = ConnectionManager()


async def websocket_connect(websocket: WebSocket, user_token: str, db: Annotated[Session, Depends(create_session)]):
    user: User = get_current_user(user_token, db)
    Logger.debug(f"[websocket_connect]: connected on a websocket: {websocket} with the user: {user.id}")

    await connection_manager.connect(websocket, user.id)
    try:
        while True:
            data: Message = Message(await websocket.receive_json())
            Logger.debug(f"[websocket_connect]: received a message from: user #{user.id}, contents: {data}")
            await connection_manager.send_message(data.receiver_id, data)
    except WebSocketDisconnect:
        connection_manager.disconnect(websocket, user.id)


def get_messages(conversation_id: int, db: Annotated[Session, Depends(create_session)],
                 user: Annotated[User, Depends(get_current_user)]):
    conversation = db.exec(select(Conversation).
                           where(Conversation == conversation_id)).first()

    # raise exception if the user is unauthorized for that conversation
    if conversation.user1_id != user.id and conversation.user2_id != user.id:
        raise CredentialsException('Unauthorized')

    # return the messages in descending order
    return db.exec(select(Message).
                   where(Message.conversation_id == conversation.id).
                   order_by(col(Message.timestamp).desc()))
