from datetime import datetime
from typing import List, Any
from sqlmodel import Session
from starlette.testclient import TestClient

from backend.models.address import Address
from backend.models.gender_identity import GenderIdentity
from backend.models.interest import Interest
from backend.models.language import Language
from backend.models.preference import Preference
from backend.models.user import User
from backend.utils.passwords import hash_pwd


RAW_PASSWORD = "pass1"


def interest(name):
    return Interest(name=name, icon="")


def language(name):
    return Language(name=name)


def gender_identity(name):
    return GenderIdentity(name=name)


def random_preferences(num):
    preferences = []
    for i in range(num):
        preferences.append(Preference(property_1=f"property{i}", property_2=f"property{i + 1}", decision=f"decision{i}",
                                      date=datetime.now()))

    return preferences


def vienna():
    return Address(
        country="Austria",
        city="Vienna",
        district="10",
        latitude_northeast=39.4,
        latitude_southwest=30.2,
        longitude_northeast=23.2,
        longitude_southwest=65.0
    )


def ulm():
    return Address(
        country="Germany",
        city="Ulm",
        district="Kesselbronn",
        latitude_northeast=2.1,
        latitude_southwest=10.2,
        longitude_northeast=20.7,
        longitude_southwest=80.9
    )


def user_alfa():
    return User(
        first_name='Alfa',
        last_name='Alfonson',
        email='alfa.alfonson@email.com',
        tel='+43 231 472 941',
        bio='Test subject',
        date_of_birth=datetime.today(),
        job='Software Engineer',
        search_radius=200,
        swipes_left=10,
        languages=[language("english")],
        gender_preferences=[gender_identity("woman")],
        preferences=random_preferences(5),
        address=vienna(),
        gender_identity=gender_identity("woman"),
        interests=[interest("sports"), interest("movies")],
        password=hash_pwd(RAW_PASSWORD)
    )


def user_beta():
    return User(
        first_name='Bravo',
        last_name='Bravonson',
        email='bravo.bravonson@email.com',
        tel='+92 231 023 953',
        bio='Test subject 2',
        date_of_birth=datetime.today(),
        job='Data Scientist',
        search_radius=50,
        swipes_left=5,
        languages=[language("english"), language("french"), language("german")],
        gender_preferences=[gender_identity("man"), gender_identity("woman")],
        preferences=random_preferences(2),
        address=ulm(),
        gender_identity=gender_identity("woman"),
        interests=[interest("travel"), interest("books"), interest("science")],
        password=hash_pwd(RAW_PASSWORD)
    )


def load_entities(entities: List[Any], session: Session):
    for entity in entities:
        session.add(entity)

    session.commit()

    for entity in entities:
        session.refresh(entity)


def login(email: str, pwd: str, client):
    headers = {"accept": "application/json", "Content-Type": "application/x-www-form-urlencoded"}
    response = client.post("/users/login", headers=headers, data={"username": f"{email}", "password": f"{pwd}"})
    return response.json()['access_token']


def authorized_request(token, client: TestClient, method, url, **kwargs):
    headers = {"accept": "application/json", "Content-Type": "application/x-www-form-urlencoded",
               "Authorization": f"Bearer {token}"}
    client.post(url)
    return method(client)(url, headers=headers, **kwargs)
