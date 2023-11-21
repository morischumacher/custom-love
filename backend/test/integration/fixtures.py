from datetime import datetime
from urllib.parse import urlencode

import pytest
from fastapi.testclient import TestClient
from fastapi_pagination import add_pagination
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
from backend.utils.passwords import hash_pwd


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


def add_test_users(session: Session):
    english: Language = Language(name="English")
    german: Language = Language(name="German")
    french: Language = Language(name="French")

    preference_1: Preference = Preference(property_1="property1", property_2="property4", decision="decision1", date=datetime.today())
    preference_2: Preference = Preference(property_1="property2", property_2="property5", decision="decision2", date=datetime.today())

    ulm: Address = Address(
        country="Germany",
        city="Ulm",
        district="Kesselbronn",
        latitude_northeast=2.1,
        latitude_southwest=10.2,
        longitude_northeast=20.7,
        longitude_southwest=80.9
    )

    vienna: Address = Address(
        country="Austria",
        city="Vienna",
        district="10",
        latitude_northeast=39.4,
        latitude_southwest=30.2,
        longitude_northeast=23.2,
        longitude_southwest=65.0
    )

    man = GenderIdentity(name="man")
    woman = GenderIdentity(name="woman")

    sports = Interest(name="sports", icon="icon1")
    movies = Interest(name="movies", icon="icon2")
    travel = Interest(name="travel", icon="icon3")
    books = Interest(name="books", icon="icon4")
    science = Interest(name="science", icon="icon5")

    user_alfa = User(
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
        gender_preferences=[woman],
        preferences=[preference_2],
        address=vienna,
        gender_identity=man,
        interests=[sports, movies],
        password=hash_pwd("pass1")
    )

    user_bravo = User(
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
        gender_preferences=[man, woman],
        preferences=[preference_1],
        address=ulm,
        gender_identity=woman,
        interests=[travel, books, science],
        password=hash_pwd("pass1")
    )

    session.add(user_alfa)
    session.add(user_bravo)
    session.commit()


def login(client: TestClient, username: str, password: str):
    headers = {"accept": "application/json", "Content-Type": "application/x-www-form-urlencoded"}
    data_encoded = urlencode({"username": username, "password": password})
    response = client.post("/users/login", headers=headers, data={"username": username, "password": password})

    return response.json()["access_token"]


def authorized_call(client: TestClient, token: str, method, url):
    headers = {"accept": "application/json", "Content-Type": "application/x-www-form-urlencoded",
               "Authorization": f"Bearer {token}"}
    try:
        client.get(url, headers=headers)
        response = method(client)(url, headers=headers)
    except Exception as e:
        raise e

    return response
