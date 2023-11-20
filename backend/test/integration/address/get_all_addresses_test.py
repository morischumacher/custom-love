from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.models.address import Address


def test_get_all_addresses(client, session):

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

    session.add(ulm)
    session.add(vienna)
    session.commit()


    response = client.get("/addresses/")
    print(f"got addresses: {response.json()}")
    assert response.status_code == 200
