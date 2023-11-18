from typing import Any
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from backend.models.message import Message


class ConnectionManager:
    def __init__(self):
        self.active_connections: dict[int, set[WebSocket]] = dict()

    async def connect(self, socket: WebSocket, user_id: int):
        await socket.accept()

        # a user can have multiple websocket connections at a time
        if self.active_connections.get(user_id) is None:
            self.active_connections[user_id] = set()

        # if a socket is already registered (TODO: log warning)
        if socket in self.active_connections.get(user_id):
            return

        self.active_connections.get(user_id).add(socket)
        print(f"added a websocket for a user: {user_id}")

    def disconnect(self, socket: WebSocket, user_id: int):
        # if the user is not present, emit a warning (TODO)
        if self.active_connections.get(user_id) is None:
            return

        try:
            self.active_connections.get(user_id).remove(socket)
        except KeyError as e:
            # TODO: log warning
            return

        print(f"disconnected from: {user_id}")

    async def send_message(self, receiver_id: int, message: Message):
        print(f"sending to {receiver_id}")

        # ignore if the user was not live
        if self.active_connections.get(receiver_id) is None:
            print("ignoring")
            return

        for socket in self.active_connections.get(receiver_id):
            await socket.send_json(message.json())

        print("sent")
