from typing import Annotated, List  #
from fastapi import APIRouter, Depends
from fastapi_pagination import Page
from fastapi_pagination.ext.async_sqlmodel import paginate
from starlette import status
from backend.models.message import Message
from backend.responses.error_response import ErrorResponse
from backend.services.message import websocket_connect, get_messages

router = APIRouter(prefix='/messages', tags=['messages'], responses={status.HTTP_200_OK: {"description": "Success"}})


@router.websocket("/socket/{user_token}")
async def socket(commons: Annotated[dict, Depends(websocket_connect)]):
    return commons


@router.get("/{conversation_id}", response_model=Page[Message], responses={
    status.HTTP_401_UNAUTHORIZED: {"description": "unauthorized", "model": ErrorResponse}
})
def get_messages(commons: Annotated[List[Message], Depends(get_messages)]):
    return paginate(commons)
