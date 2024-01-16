import json
import io

from fastapi import UploadFile

from backend.models.gender_identity import GenderIdentity
from backend.models.interest import Interest
from backend.models.language import Language
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session


def test_post_create_user(client, session):
    man = GenderIdentity(name="man")
    woman = GenderIdentity(name="woman")
    divers = GenderIdentity(name="divers")

    sports = Interest(name="sports", icon="icon1")
    movies = Interest(name="movies", icon="icon2")
    travel = Interest(name="travel", icon="icon3")
    books = Interest(name="books", icon="icon4")

    english = Language(name="english")
    german = Language(name="german")
    french = Language(name="french")

    session.add(man)
    session.add(woman)
    session.add(divers)

    session.add(sports)
    session.add(movies)
    session.add(travel)
    session.add(books)

    session.add(english)
    session.add(german)
    session.add(french)

    session.commit()

    headers = {
        "Content-Type": "application/x-www-form-urlencoded",
        'accept': 'application/json'
    }

    response = client.post(
        "/users/",
        headers=headers,
        data={
            "gender_identity_id": 1,
            "first_name": "Stefan",
            "last_name": "Müller",
            "email": "stefan1.mueller@email.com",
            "password": "pass1",
            "bio": "Test subject",
            "date_of_birth": "1990-11-17T20:06:55.441841",
            "job": "Software Engineer",
            "search_radius": 200,
            "matching_algorithm": 1,
            "swipes_left": 10,
            "swipe_limit_reset_date": "2023-11-17T20:06:55.441841",
            "gender_preference_ids": "[1, 2]",
            "interest_ids": "[1, 2, 3]",
            "language_ids": "[1]",
            "latitude": 20,
            "longitude": 20,
        }
    )
    print(f"created user: {response.json()}")
    assert response.status_code == 200
