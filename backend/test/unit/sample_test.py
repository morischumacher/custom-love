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
from backend.models.gender_preference import GenderPreference
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
    gender_preference_1: GenderPreference = GenderPreference(name="women")
    gender_preference_2: GenderPreference = GenderPreference(name="men")

    session.add(gender_preference_1)
    session.add(gender_preference_2)
    session.commit()

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
    man = GenderIdentity(name="man")
    woman = GenderIdentity(name="woman")

    session.add(man)
    session.add(woman)
    session.commit()

    # Interest
    sports = Interest(name="sports", icon="icon1")
    movies = Interest(name="movies", icon="icon2")
    travel = Interest(name="travel", icon="icon3")
    books = Interest(name="books", icon="icon4")
    science = Interest(name="science", icon="icon5")

    session.add(sports)
    session.add(movies)
    session.add(travel)
    session.add(books)
    session.add(science)
    session.commit()

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
        gender_preferences=[gender_preference_1],
        address=vienna,
        gender_identity=man,
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
        gender_preferences=[gender_preference_2, gender_preference_1],
        address=ulm,
        gender_identity=woman,
        interests=[travel, books, science]
    )

    # Rating
    alfa_bravo_rating = Rating(rating_user_id=user_alfa.id, rated_user_id=user_bravo.id, is_safe=True)

    session.add(alfa_bravo_rating)
    session.commit()

    """
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
    session.refresh(alfa_bravo_matching)"""

    """response = client.get("/users/1")
    print(f"got user: {response.json()}")
    assert response.status_code == 200"""

    """response = client.get("/addresses/1")
    print(f"got address: {response.json()}")
    assert response.status_code == 200"""

    """response = client.get("/language/1")
    print(f"got language: {response.json()}")
    assert response.status_code == 200"""

    """response = client.get("/match/1")
    print(f"got match: {response.json()}")
    assert response.status_code == 200"""

    # Rating getById
    response = client.get("/ratings/1")
    print(f"got rating: {response.json()}")
    assert response.status_code == 200

    # Rating create
    response = client.post("/ratings/", json={"rating_user_id": user_alfa.id, "rated_user_id": user_bravo.id, "is_safe": True})
    print(f"got rating: {response.json()}")
    assert response.status_code == 200

    # Rating getAll
    response = client.get("/ratings/")
    print(f"got rating: {response.json()}")
    assert response.status_code == 200


def test_get_interest_by_id(client: TestClient, session: Session):
    sports = Interest(name="sports", icon="icon1")
    movies = Interest(name="movies", icon="icon2")
    travel = Interest(name="travel", icon="icon3")

    session.add(sports)
    session.add(movies)
    session.add(travel)
    session.commit()

    response = client.get("/interests/3")
    print(f"got interest: {response.json()}")
    assert response.status_code == 200


def test_get_interests(client: TestClient, session: Session):
    sports = Interest(name="sports", icon="icon1")
    movies = Interest(name="movies", icon="icon2")
    travel = Interest(name="travel", icon="icon3")
    books = Interest(name="books", icon="icon4")
    science = Interest(name="science", icon="icon5")

    session.add(sports)
    session.add(movies)
    session.add(travel)
    session.add(books)
    session.add(science)
    session.commit()

    response = client.get("/interests/")
    print(f"got interest: {response.json()}")
    assert response.status_code == 200


def test_create_interest(client: TestClient, session: Session):
    response = client.post("/interests/", json={"name": "theater", "icon": "icon6"})
    print(f"got interest: {response.json()}")
    assert response.status_code == 200


def test_get_gender_preference_by_id(client: TestClient, session: Session):
    gender_preference_1: GenderPreference = GenderPreference(name="women")
    gender_preference_2: GenderPreference = GenderPreference(name="men")

    session.add(gender_preference_1)
    session.add(gender_preference_2)
    session.commit()

    response = client.get("/gender-preferences/1")
    print(f"got gender preference: {response.json()}")
    assert response.status_code == 200


def test_get_gender_preferences(client: TestClient, session: Session):
    gender_preference_1: GenderPreference = GenderPreference(name="women")
    gender_preference_2: GenderPreference = GenderPreference(name="men")

    session.add(gender_preference_1)
    session.add(gender_preference_2)
    session.commit()

    response = client.get("/gender-preferences/")
    print(f"got gender preference: {response.json()}")
    assert response.status_code == 200


def test_create_gender_preference(client: TestClient, session: Session):
    response = client.post("/gender-preferences/", json={"name": "women and men"})
    print(f"got gender preferences: {response.json()}")
    assert response.status_code == 200

def test_get_gender_identity_by_id(client: TestClient, session: Session):
    man = GenderIdentity(name="man")
    woman = GenderIdentity(name="woman")

    session.add(man)
    session.add(woman)
    session.commit()

    response = client.get("/gender-identities/1")
    print(f"got gender-identity: {response.json()}")
    assert response.status_code == 200


def test_get_gender_identities(client: TestClient, session: Session):
    man = GenderIdentity(name="man")
    woman = GenderIdentity(name="woman")

    session.add(man)
    session.add(woman)
    session.commit()

    response = client.get("/gender-identities/")
    print(f"got gender-identity: {response.json()}")
    assert response.status_code == 200


def test_create_gender_identity(client: TestClient, session: Session):
    response = client.post("/gender-identities/",
                           json={"name": "divers"})
    print(f"got gender-identity: {response.json()}")
    assert response.status_code == 200
