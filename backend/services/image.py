from datetime import datetime
from typing import Annotated, List

from fastapi import Depends, UploadFile
from sqlalchemy import LargeBinary
from sqlmodel import Session, select, or_, and_

from backend.exceptions.credentials_exception import CredentialsException
from backend.exceptions.not_found_exception import NotFoundException
from backend.models.conversation import Conversation
from backend.models.image import Image, ProfilePicture
from backend.models.message import Message
from backend.models.user import User
from backend.repository.repository import create_session
from backend.utils.token import get_current_user
from fastapi import Response


# region chat images

def get_image(image_id: int, user: Annotated[User, Depends(get_current_user)],
              db: Annotated[Session, Depends(create_session)]):
    image = db.exec(select(Image).where(Image.id == image_id)).first()

    if image is None:
        raise NotFoundException(f"Image with id: #{image_id} not found")

    if image.conversation.user2_id != user.id and image.conversation.user1_id != user.id:
        raise CredentialsException("Unauthorized call")

    return Response(content=image.content, media_type=image.content_type)


async def post_image(receiver_id: int, user: Annotated[User, Depends(get_current_user)],
                     db: Annotated[Session, Depends(create_session)], file: UploadFile):
    # get the targeted conversation
    conversation = db.exec(select(Conversation).where(
        or_(
            and_(Conversation.user1_id == user.id, Conversation.user2_id == receiver_id),
            and_(Conversation.user1_id == receiver_id, Conversation.user2_id == user.id)
        )
    )).first()

    # raise error, when no conversation between the target users exist
    if conversation is None:
        raise NotFoundException(f"No conversation between the users: #{receiver_id} and #{user.id} found")

    image = Image(conversation_id=conversation.id, content=file.file.read(), filename=file.filename, content_type=file.content_type)

    # add the image to the db
    db.add(image)
    db.commit()
    db.refresh(image)

    # create a corresponding message object
    message = Message(
        is_image=True,
        conversation_id=conversation.id,
        sender_id=user.id,
        receiver_id=receiver_id,
        message=str(image.id),
        timestamp=datetime.now()
    )

    # add the message object to the db
    db.add(message)
    db.commit()
    db.refresh(message)

    return message

# endregion


# region profile pictures

def get_profile_pictures(user: Annotated[User, Depends(get_current_user)], db: Annotated[Session, Depends(create_session)]):
    return map(
        lambda element: element.id,
        db.exec(select(ProfilePicture).where(ProfilePicture.user_id == user.id)).all(),
    )


def get_profile_picture(image_id: int, user: Annotated[User, Depends(get_current_user)], db: Annotated[Session, Depends(create_session)]):
    image = db.exec(select(ProfilePicture).where(ProfilePicture.id == image_id)).first()

    if image is None:
        raise NotFoundException(f"Image with the id: #{image_id} was not found")

    if image.user_id != user.id:
        raise CredentialsException("Unauthorized call")

    return Response(content=image.content, media_type=image.content_type)


def post_profile_picture(user: Annotated[User, Depends(get_current_user)],
                     db: Annotated[Session, Depends(create_session)], file: UploadFile):
    image = ProfilePicture(
        user_id=user.id,
        content=file.file.read(),
        filename=file.filename,
        content_type=file.content_type
    )

    db.add(image)
    db.commit()
    db.refresh(image)

    return {"description": "Success"}

# endregion
