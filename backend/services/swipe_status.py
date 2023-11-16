from typing import Annotated

from fastapi import Depends
from sqlmodel import Session, select
from sqlmodel.sql.expression import SelectOfScalar

from backend.exceptions.fatal_exception import FatalException
from backend.exceptions.not_found_exception import NotFoundException
from backend.exceptions.validation_exception import ValidationException
from backend.models.swipe_status import SwipeStatus, SwipeStatusType
from backend.repository.repository import create_session


def get_swipe_status(db: Annotated[Session, Depends(create_session)], match_id: int):
    """
    Retrieves all matches with a matching id.
    :param db: database provided through dependency injection
    :param match_id: id of the match searched for
    :return: match with a matching id
    """
    statement = select(SwipeStatus).where(SwipeStatus.id == match_id)
    match: list[SwipeStatus] = db.exec(statement).all()
    if len(match) == 0:
        raise NotFoundException(f"Could not find match with id = {match_id}")
    elif len(match) > 1:
        raise FatalException(f"More than one match with id = {match_id} was found")
    return match


def get_all_user_swipe_statuses(db: Annotated[Session, Depends(create_session)], user_id: int, is_match: SwipeStatusType | None = None):
    """
    Retrieves all matches belonging to a user.
    :param db: database provided through dependency injection
    :param user_id: id of the user whose matches are searched for
    :param is_match: Filters matches which correspond to the provided boolean value
    :return: list of matches
    """
    if is_match is None:
        statement1 = select(SwipeStatus).where(
            SwipeStatus.user1_id == user_id, SwipeStatus.user2_id != user_id
        )
        statement2 = select(SwipeStatus).where(
            SwipeStatus.user1_id != user_id, SwipeStatus.user2_id == user_id
        )
    else:
        statement1 = select(SwipeStatus).where(
            SwipeStatus.user1_id == user_id, SwipeStatus.user2_id != user_id, SwipeStatus.status == is_match
        )
        statement2 = select(SwipeStatus).where(
            SwipeStatus.user1_id != user_id, SwipeStatus.user2_id == user_id, SwipeStatus.status == is_match
        )
    match: list[SwipeStatus] = db.exec(statement1).all() + db.exec(statement2).all()
    return match


def get_swipe_statuses(db: Annotated[Session, Depends(create_session)], user_id: int | None = None, is_match: bool | None = None):
    """
    Retrieves all matches contained within the database.
    :param db: database provided through dependency injection
    :param is_match: Filters matches which correspond to the provided boolean value
    :return: list of matches
    """
    if user_id is not None:
        get_all_user_swipe_statuses(db, user_id, is_match)
    else:
        if is_match is None:
            statement: SelectOfScalar[SwipeStatus] = select(SwipeStatus)
        else:
            statement: SelectOfScalar[SwipeStatus] = select(SwipeStatus).where(SwipeStatus.status == is_match)
        matches: list[SwipeStatus] = db.exec(statement).all()
        return matches


def post_match(db: Annotated[Session, Depends(create_session)], swipe_status: SwipeStatus):
    """
    Stores a model object in the database.
    :param db: database provided through dependency injection
    :param swipe_status: match object to be stored
    :return: newly stored match
    """
    if swipe_status.user1_id == swipe_status.user2_id:
        raise ValidationException("Cannot match a person with itself")

    db.add(swipe_status)
    db.commit()
    db.refresh(swipe_status)
    return swipe_status
