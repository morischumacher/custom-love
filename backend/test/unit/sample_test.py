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
from backend.models.match import Match
from backend.models.preference import Preference
from backend.models.rating import Rating
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
    # Languages
    english: Language = Language(id=1, name="English")
    german: Language = Language(id=2, name="German")
    french: Language = Language(id=3, name="French")

    # Preferences
    preference_1: Preference = Preference(id=1, feature_1_level="Feature 1", feature_2_level="Feature 2")
    preference_2: Preference = Preference(id=2, feature_1_level="Feature 3", feature_2_level="Feature 4")

    # Addresses
    ulm: Address = Address(
        id=1,
        country="Germany",
        city="Ulm",
        district="Kesselbronn",
        latitude_northeast=2.1,
        latitude_southwest=10.2,
        longitude_northeast=20.7,
        longitude_southwest=80.9
    )
    vienna: Address = Address(
        id=2,
        country="Austria",
        city="Vienna",
        district="10",
        latitude_northeast=39.4,
        latitude_southwest=30.2,
        longitude_northeast=23.2,
        longitude_southwest=65.0
    )

    # Gender Identity
    hetero = GenderIdentity(name="hetero-sexual")
    homo = GenderIdentity(name="homo-sexual")
    # bi = GenderIdentity(name="bi-sexual")

    # Interest
    sports = Interest(id=1, name="sports", icon="icon1")
    movies = Interest(id=2, name="movies", icon="icon2")
    travel = Interest(id=3, name="travel", icon="icon3")
    books = Interest(id=4, name="books", icon="icon4")
    science = Interest(id=5, name="science", icon="icon5")

    # Users
    user_alfa = User(
        id=1,
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
    user_bravo = User(
        id=2,
        first_name='Bravo',
        last_name='Bravonson',
        email='bravo.bravonson@email.com',
        tel='+92 231 023 953',
        bio='Test subject 2',
        date_of_birth=datetime.today(),
        job='Data Scientist',
        search_radius=50,
        swipes_left=5,
        languages=[english, french, german],
        preferences=[preference_2, preference_1],
        address=ulm,
        gender_identity=homo,
        interests=[travel, books, science]
    )

    # Rating
    alfa_bravo_rating = Rating(id=1, rating_user_id=user_alfa.id, rated_user_id=user_bravo.id, rating=10)

    # Match
    alfa_bravo_matching = Match(id=1, match_user1_id=user_alfa.id, match_user2_id=user_bravo.id, is_match=True)

    session.add(user_alfa)
    session.add(user_bravo)
    session.commit()

    session.refresh(user_alfa)
    session.refresh(user_bravo)

    session.add(alfa_bravo_rating)
    session.add(alfa_bravo_matching)
    session.commit()
    session.refresh(alfa_bravo_rating)
    session.refresh(alfa_bravo_matching)

    response = client.get("/user/1")
    print(f"got user: {response.json()}")
    assert response.status_code == 200

    response = client.get("/address/1")
    print(f"got address: {response.json()}")
    assert response.status_code == 200

    response = client.get("/language/1")
    print(f"got language: {response.json()}")
    assert response.status_code == 200

    response = client.get("/preference/4")
    print(f"got preference: {response.json()}")
    assert response.status_code == 200

    response = client.get("/match/1")
    print(f"got match: {response.json()}")
    assert response.status_code == 200

    response = client.get("/rating/1")
    print(f"got rating: {response.json()}")
    assert response.status_code == 200

    response = client.get("/interest/3")
    print(f"got interest: {response.json()}")
    assert response.status_code == 200

