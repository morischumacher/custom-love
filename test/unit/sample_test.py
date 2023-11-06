import pytest
from fastapi.testclient import TestClient
from sqlmodel import Session, SQLModel, create_engine
from sqlmodel.pool import StaticPool

from backend.main import app
from backend.models.user import User
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
    client = TestClient(app)
    yield client
    app.dependency_overrides.clear()


def test_sample_user_get(client: TestClient, session: Session):
    user_1 = User("manual")

    # add a user to the mock db manually
    session.add(user_1)
    session.commit()

    response = client.get("/user/1")
    print(f"got users: {response.json()}")
    assert response.status_code == 200
