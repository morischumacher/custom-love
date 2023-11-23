from typing import Any
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from backend.models.message import Message
from backend.utils.logger import Logger


class ConnectionManager:
    def __init__(self):
        self.active_connections: dict[int, set[WebSocket]] = dict()

    async def connect(self, socket: WebSocket, user_id: int):
        await socket.accept()

        # a user can have multiple websocket connections at a time
        if self.active_connections.get(user_id) is None:
            self.active_connections[user_id] = set()

        if socket in self.active_connections.get(user_id):
            Logger.warning(f"[ConnectionManager.connect] a socket: {socket} for the user: #{user_id} was already "
                           f"registered")
            return

        self.active_connections.get(user_id).add(socket)
        Logger.debug(f"[ConnectionManager.connect] added a websocket for a user: {user_id}")

    def disconnect(self, socket: WebSocket, user_id: int):
        if self.active_connections.get(user_id) is None:
            Logger.warning(f"[ConnectionManager.disconnect] user: #{user_id} was not present in the users dictionary")
            return

        try:
            self.active_connections.get(user_id).remove(socket)
        except KeyError as e:
            Logger.warning(f"[Connection.Manager.disconnect] the socket of user #{user_id} has been deleted before")
            return

        Logger.debug(f"[ConnectionManager.disconnect] disconnected from user: #{user_id}")

    async def send_message(self, receiver_id: int, message: Message):
        Logger.debug(f"[ConnectionManager.send_message] sending message #{message.id} to {receiver_id}")

        # ignore if the user was not live
        if self.active_connections.get(receiver_id) is None:
            Logger.debug(f"[ConnectionManager.send_message] user #{receiver_id} was not live")
            return

        # send to every the given user's every open socket
        for socket in self.active_connections.get(receiver_id):
            await socket.send_json(message.json())
