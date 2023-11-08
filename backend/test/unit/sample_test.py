from datetime import datetime

import pytest
from fastapi.testclient import TestClient
from sqlmodel import Session, SQLModel, create_engine
from sqlmodel.pool import StaticPool

from backend.main import app
from backend.models.address import Address
from backend.models.gender_identity import GenderIdentity
from backend.models.interest import Interest
from backend.models.language import Language
from backend.models.preference import Preference
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
    english: Language = Language(name="English")

    # Preferences
    preference_1: Preference = Preference(feature_1_level="Feature 1", feature_2_level="Feature 2")

    # Addresses
    vienna: Address = Address(
        country="Austria",
        city="Vienna",
        district="10",
        latitude_northeast=39.4,
        latitude_southwest=30.2,
        longitude_northeast=23.2,
        longitude_southwest=65.0
    )

    # Interest
    sports = Interest(name="sports", icon="icon1")
    movies = Interest(name="movies", icon="icon2")

    hetero = GenderIdentity(name="hetero-sexual")

    # Users
    user_1 = User(
        first_name='Alfa',
        last_name='Alfonson',
        email='alfa.alfonson@email.com',
        tel='+43 231 472 941',
        bio='Test subject',
        date_of_birth=datetime.today(),
        job='Software Engineer',
        search_radius=200,
        swipes_left=10,
        languages=[english],
        preferences=[preference_1],
        address=vienna,
        gender_identity=hetero,
        interests=[sports, movies]
    )

    # add a user to the mock db manually
    session.add(user_1)
    session.commit()

    response = client.get("/user/1")
    print(f"got users: {response.json()}")
    assert response.status_code == 200
