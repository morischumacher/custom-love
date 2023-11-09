from sqlmodel import Session, select
from sqlmodel.sql.expression import SelectOfScalar

from backend.models.language import Language
from backend.repository.repository import get_engine


def get_languages():
    with Session(get_engine()) as session:
        statement: SelectOfScalar[Language] = select(Language)
        languages: list[Language] = session.exec(statement).all()
    return languages
