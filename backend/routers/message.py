from typing import Annotated#
from fastapi import APIRouter, Depends
from starlette import status
from starlette.responses import HTMLResponse

from backend.services.message import websocket_connect

router = APIRouter(prefix='/messages', tags=['messages'], responses={status.HTTP_200_OK: {"description": "Success"}})


@router.websocket("/socket/{user_token}")
async def socket(commons: Annotated[dict, Depends(websocket_connect)]):
    return commons
