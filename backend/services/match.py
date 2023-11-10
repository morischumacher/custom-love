from sqlmodel import Session, select
from sqlmodel.sql.expression import SelectOfScalar

from backend.exceptions.fatal_exception import FatalException
from backend.exceptions.not_found_exception import NotFoundException
from backend.exceptions.validation_exception import ValidationException
from backend.models.match import Match
from backend.repository.repository import get_engine


def get_match(match_id: int):
    """
    Retrieves all matches with a matching id.
    :param match_id: id of the match searched for
    :return: match with a matching id
    """
    with Session(get_engine()) as session:
        statement = select(Match).where(Match.id == match_id)
        match: list[Match] = session.exec(statement).all()
        if len(match) == 0:
            raise NotFoundException(f"Could not find match with id = {match_id}")
        elif len(match) > 1:
            raise FatalException(f"More than one match with id = {match_id} was found")
    return match


def get_all_user_matches(user_id: int, is_match: bool | None = None):
    """
    Retrieves all matches belonging to a user.
    :param user_id: id of the user whose matches are searched for
    :param is_match: Filters matches which correspond to the provided boolean value
    :return: list of matches
    """
    with Session(get_engine()) as session:
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
        match: list[Match] = session.exec(statement1).all() + session.exec(statement2).all()
    return match


def get_matches(is_match: bool | None):
    """
    Retrieves all matches contained within the database.
    :param is_match: Filters matches which correspond to the provided boolean value
    :return: list of matches
    """
    with Session(get_engine()) as session:
        if is_match is None:
            statement: SelectOfScalar[Match] = select(Match)
        else:
            statement: SelectOfScalar[Match] = select(Match).where(Match.is_match == is_match)
        matches: list[Match] = session.exec(statement).all()
    return matches


def post_match(match: Match):
    """
    Stores a model object in the database.
    :param match: match object to be stored
    :return: newly stored match
    """
    if match.match_user1_id == match.match_user2_id:
        raise ValidationException("Cannot match a person with itself")

    with Session(get_engine()) as session:
        session.add(match)
        session.commit()
        session.refresh(match)
    return match
