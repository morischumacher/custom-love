import json

from sqlmodel import create_engine, Session, SQLModel


def get_engine():
    with open('backend/database.json') as file:
        connection_string = json.load(file)

    return create_engine(f"{connection_string['prefix']}://{connection_string['user']}:"
                         f"{connection_string['password']}@{connection_string['address']}/"
                         f"{connection_string['database']}", echo=True)


def create_db():
    engine = get_engine()
    SQLModel.metadata.create_all(engine)


def create_session():
    engine = get_engine()
    with Session(engine) as session:
        yield session
