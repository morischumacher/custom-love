from typing import Annotated, List

from fastapi import Depends
from sqlmodel import Session, select, or_
from sqlmodel.sql.expression import SelectOfScalar

from backend.exceptions.fatal_exception import FatalException
from backend.exceptions.not_found_exception import NotFoundException
from backend.exceptions.validation_exception import ValidationException
from backend.models.swipe_status import SwipeStatus, SwipeStatusType
from backend.models.user import User
from backend.repository.repository import create_session
from backend.security.token import get_current_user


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


def get_matches(
        db: Annotated[Session, Depends(create_session)],
        user: Annotated[User, Depends(get_current_user)],
):
    matches: List[SwipeStatus] = db.exec(select(SwipeStatus).where(
        SwipeStatus.status == SwipeStatusType.match,
        or_(SwipeStatus.user1_id == user.id, SwipeStatus.user2_id == user.id)
    )).all()
    return matches


def post_view(
        db: Annotated[Session, Depends(create_session)],
        user: Annotated[User, Depends(get_current_user)],
        user_id: int
) -> SwipeStatus:
    """
    Stores a model object in the database.
    :param db: database provided through dependency injection
    :param user: user currently logged in
    :param user_id: id of the other user
    :return: newly stored match
    """
    if user.id == user_id:
        raise ValidationException("User trying to match him- or herself")
    existing_entry_1 = db.exec(select(SwipeStatus).where(
        SwipeStatus.user1_id == user.id, SwipeStatus.user2_id == user_id
    )).all()
    existing_entry_2 = db.exec(select(SwipeStatus).where(
        SwipeStatus.user2_id == user.id, SwipeStatus.user1_id == user_id
    )).all()

    if len(existing_entry_1) > 0 or len(existing_entry_2) > 0:
        raise ValidationException("Swipe already exists")

    new_swipe_status = SwipeStatus(
        user1_id=user.id,
        user2_id=user_id,
        status=SwipeStatusType.view
    )

    db.add(new_swipe_status)
    db.commit()
    db.refresh(new_swipe_status)

    swipe_statuses = db.execute(select(SwipeStatus)).all()
    stored_status: SwipeStatus = swipe_statuses[len(swipe_statuses) - 1][0]
    return stored_status


def post_like(
        db: Annotated[Session, Depends(create_session)],
        user: Annotated[User, Depends(get_current_user)],
        user_id: int
):
    """
    Stores a model object in the database.
    :param db: database provided through dependency injection
    :param user: user currently logged in
    :param user_id: id of the other user
    :return: newly stored match
    """
    if user.id == user_id:
        raise ValidationException("Cannot match a person with itself")

    existing_entry = db.exec(select(SwipeStatus).where(or_(
        SwipeStatus.user1_id == user.id, SwipeStatus.user2_id == user_id,
        SwipeStatus.user2_id == user.id, SwipeStatus.user1_id == user_id
    ), or_(SwipeStatus.status == SwipeStatusType.like, SwipeStatus.status == SwipeStatusType.match))).all()

    existing_entry_1 = db.exec(select(SwipeStatus).where(
        SwipeStatus.user1_id == user.id, SwipeStatus.user2_id == user_id,
        or_(SwipeStatus.status == SwipeStatusType.like, SwipeStatus.status == SwipeStatusType.match))).all()
    existing_entry_2 = db.exec(select(SwipeStatus).where(
        SwipeStatus.user2_id == user.id, SwipeStatus.user1_id == user_id,
        or_(SwipeStatus.status == SwipeStatusType.like, SwipeStatus.status == SwipeStatusType.match))).all()

    if len(existing_entry_1) > 1 or len(existing_entry_2) > 1:
        raise ValidationException("Too many swipe-statuses for the same pair")

    if len(existing_entry_1) > 0 or len(existing_entry_2) > 0:
        new_swipe_status = existing_entry[0]
        if new_swipe_status.status == SwipeStatusType.match:
            raise ValidationException("Already stored as a match")
        new_swipe_status.status = SwipeStatusType.match
    else:
        new_swipe_status = SwipeStatus(
            user1_id=user.id,
            user2_id=user_id,
            status=SwipeStatusType.like
        )

    db.add(new_swipe_status)
    db.commit()
    db.refresh(new_swipe_status)

    swipe_statuses = db.execute(select(SwipeStatus)).all()
    stored_status: SwipeStatus = swipe_statuses[len(swipe_statuses) - 1][0]
    return stored_status
