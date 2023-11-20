import pytest
from fastapi.testclient import TestClient
from fastapi_pagination import add_pagination
from sqlmodel import Session, SQLModel, create_engine
from sqlmodel.pool import StaticPool

from backend.main import app
from backend.repository.repository import create_session


@pytest.fixture(name="session")
def session_fixture():
    engine = create_engine(
        "sqlite://",
        connect_args={"check_same_thread": False},
        poolclass=StaticPool,
    )
    SQLModel.metadata.create_all(engine)
    with Session(engine) as session:
        yield session


@pytest.fixture(name="client")
def client_fixture(session: Session):
    def create_session_override():
        return session

    app.dependency_overrides[create_session] = create_session_override
    add_pagination(app)
    client = TestClient(app)
    yield client
    app.dependency_overrides.clear()