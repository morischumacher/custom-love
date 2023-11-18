from typing import Annotated  #
from fastapi import APIRouter, Depends
from fastapi_pagination import Page
from fastapi_pagination.ext.async_sqlalchemy import paginate
from starlette import status
from starlette.responses import HTMLResponse

from backend.models.conversation import Conversation
from backend.responses.error_response import ErrorResponse
from backend.services.conversation import get_conversations, post_conversation
from backend.services.message import websocket_connect

router = APIRouter(prefix='/conversations', tags=['conversations'], responses={
    status.HTTP_200_OK: {"description": "Success"},
    status.HTTP_401_UNAUTHORIZED: {"description": "Error: Unauthorized", "model": ErrorResponse}
})


@router.get("/", response_model=Page[Conversation])
def get_conversations(commons: Annotated[dict, Depends(get_conversations)]):
    return paginate(commons)


@router.post("/{user_id}", response_model=Conversation)
def post_conversation(commons: Annotated[Conversation, Depends(post_conversation)]):
    return commons
