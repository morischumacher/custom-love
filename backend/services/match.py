from typing import Annotated

from fastapi import Depends
from sqlmodel import Session, select
from sqlmodel.sql.expression import SelectOfScalar

from backend.exceptions.bad_request_exception import BadRequestException
from backend.exceptions.not_found_exception import NotFoundException
from backend.exceptions.validation_exception import ValidationException
from backend.models.match import Match
from backend.repository.repository import create_session


def get_match(db: Annotated[Session, Depends(create_session)], match_id: int):
    """
    Retrieves all matches with a matching id.
    :param db: database provided through dependency injection
    :param match_id: id of the match searched for
    :return: match with a matching id
    """
    statement = select(Match).where(Match.id == match_id)
    match: list[Match] = db.exec(statement).all()
    if len(match) == 0:
        raise NotFoundException(f"Could not find match with id = {match_id}")
    elif len(match) > 1:
        raise BadRequestException(f"More than one match with id = {match_id} was found")
    return match


def get_all_user_matches(db: Annotated[Session, Depends(create_session)], user_id: int, is_match: bool | None = None):
    """
    Retrieves all matches belonging to a user.
    :param db: database provided through dependency injection
    :param user_id: id of the user whose matches are searched for
    :param is_match: Filters matches which correspond to the provided boolean value
    :return: list of matches
    """
    if is_match is None:
        statement1 = select(Match).where(
            Match.match_user1_id == user_id, Match.match_user2_id != user_id
        )
        statement2 = select(Match).where(
            Match.match_user1_id != user_id, Match.match_user2_id == user_id
        )
    else:
        statement1 = select(Match).where(
            Match.match_user1_id == user_id, Match.match_user2_id != user_id, Match.is_match == is_match
        )
        statement2 = select(Match).where(
            Match.match_user1_id != user_id, Match.match_user2_id == user_id, Match.is_match == is_match
        )
    match: list[Match] = db.exec(statement1).all() + db.exec(statement2).all()
    return match


def get_matches(db: Annotated[Session, Depends(create_session)], user_id: int | None = None, is_match: bool | None = None):
    """
    Retrieves all matches contained within the database.
    :param db: database provided through dependency injection
    :param is_match: Filters matches which correspond to the provided boolean value
    :return: list of matches
    """
    if user_id is not None:
        get_all_user_matches(db, user_id, is_match)
    else:
        if is_match is None:
            statement: SelectOfScalar[Match] = select(Match)
        else:
            statement: SelectOfScalar[Match] = select(Match).where(Match.is_match == is_match)
        matches: list[Match] = db.exec(statement).all()
        return matches


def post_match(match: Match, db: Annotated[Session, Depends(create_session)]):
    """
    Stores a model object in the database.
    :param db: database provided through dependency injection
    :param match: match object to be stored
    :return: newly stored match
    """
    if match.match_user1_id == match.match_user2_id:
        raise ValidationException("Cannot match a person with itself")

    db.add(match)
    db.commit()
    db.refresh(match)
    return match
