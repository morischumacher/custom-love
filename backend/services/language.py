from typing import Annotated, List

from fastapi import Depends
from sqlmodel import Session, select
from sqlmodel.sql.expression import SelectOfScalar

from backend.models.language import Language
from backend.repository.repository import create_session


def get_languages(db: Annotated[Session, Depends(create_session)]) -> List[Language]:
    """
    Return a list of all languages
    :return: a list of all languages
    """
    statement: SelectOfScalar[Language] = select(Language)
    languages: list[Language] = db.exec(statement).all()
    return languages
