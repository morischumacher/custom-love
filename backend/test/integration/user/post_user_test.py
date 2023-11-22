from backend.models.address import Address
from backend.models.gender_identity import GenderIdentity
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session


def test_post_create_user(client, session):
    ulm: Address = Address(
        country="Germany",
        city="Ulm",
        district="Kesselbronn",
        latitude_northeast=2.1,
        latitude_southwest=10.2,
        longitude_northeast=20.7,
        longitude_southwest=80.9
    )

    woman = GenderIdentity(name="woman")

    session.add(ulm)
    session.add(woman)

    session.commit()

    response = client.post("/users/", json={
        "gender_identity_id": 1,
        "address_id": 2,
        "first_name": "Stefan",
        "last_name": "Müller",
        "email": "stefan.mueller@email.com",
        "password": "$2b$12$DbeUp0dne14ZWdIHhgGdN.ekwUY/eXfHxWiFnKum53mAtf8eNPTjW",
        "bio": "Test subject",
        "date_of_birth": "1990-11-17T20:06:55.441841",
        "job": "Software Engineer",
        "search_radius": 200,
        "swipes_left": 10
    })

    print(f"created user: {response.json()}")
    assert response.status_code == 200
