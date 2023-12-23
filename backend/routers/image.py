from typing import Annotated, List, Dict

from fastapi import APIRouter, Depends
from fastapi.openapi.models import Response
from starlette import status

from backend.models.message import Message
from backend.services.image import post_image, get_image, get_profile_picture, get_profile_pictures, \
    post_profile_picture

router = APIRouter(prefix='/images', tags=['images'], responses={
    status.HTTP_200_OK: {"description": "Success"}
})


# region chat images

@router.get(path="/{image_id}")
def get_image(commons: Annotated[Response, Depends(get_image)]):
    return commons


@router.post(path="", response_model=Message)
def post_image(commons: Annotated[Message, Depends(post_image)]):
    return commons

# endregion


# region profile pictures

@router.get(path="/profile")
def get_profile_pictures(commons: Annotated[List[int], Depends(get_profile_pictures)]):
    return commons


@router.get(path="/profile/{image_id}")
def get_profile_picture(commons: Annotated[Response, Depends(get_profile_picture)]):
    return commons


@router.post(path="/profile")
def post_profile_picture(commons: Annotated[Dict, Depends(post_profile_picture)]):
    return commons

# endregion
