from typing import Annotated
from fastapi import APIRouter, Depends
from backend.utils.pagination import Page
from starlette import status
from backend.models.message import Message
from backend.responses.error_response import ErrorResponse
from backend.services.message import websocket_connect, get_messages, sockets_test

router = APIRouter(prefix='/messages', tags=['messages'], responses={status.HTTP_200_OK: {"description": "Success"}})


@router.websocket("/socket/{user_token}")
async def socket(commons: Annotated[dict, Depends(websocket_connect)]):
    return commons


@router.get("/{conversation_id}", response_model=Page[Message], responses={
    status.HTTP_401_UNAUTHORIZED: {"description": "unauthorized", "model": ErrorResponse}
})
def get_messages(commons: Annotated[Page[Message], Depends(get_messages)]):
    return commons


#  region sockets_test: this will be deleted as soon as the frontend-chat functionality is ready
@router.get("/socket/test")
def sockets_test(commons: Annotated[dict, Depends(sockets_test)]):
    """
    this is just for texting, will be deleted as soon as the frontend-chat functionality is ready
    """

    return commons

# endregion
