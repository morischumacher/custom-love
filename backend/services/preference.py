from sqlmodel import Session, select
from sqlmodel.sql.expression import SelectOfScalar

from backend.exceptions.FatalException import FatalException
from backend.exceptions.NotFoundException import NotFoundException
from backend.repository.repository import get_engine
from backend.models.preference import Preference


def get_preference(preference_id: int):
    with Session(get_engine()) as session:
        statement = select(Preference).where(Preference.id == preference_id)
        preference: list[Preference] = session.exec(statement).all()
        if len(preference) == 0:
            raise NotFoundException(f"Could not find users with id = {preference_id}")
        elif len(preference) > 1:
            raise FatalException(f"More than one user for id = {preference_id} was found")
    return preference


def get_preferences():
    with Session(get_engine()) as session:
        statement: SelectOfScalar[Preference] = select(Preference)
        preferences: list[Preference] = session.exec(statement).all()
    return preferences


def post_preference(preference: Preference):
    with Session(get_engine()) as session:
        session.add(preference)
        session.commit()
        session.refresh(preference)
    return preference
