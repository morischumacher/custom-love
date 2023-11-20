from backend.test.integration.fixtures import client_fixture as client, session_fixture as session


def test_post_create_address(client, session):

    response = client.post("/addresses/", json={"country": "Germany", "city": "Ulm", "district": "Kesselbronn",
                                                "latitude_northeast": 2.1, "latitude_southwest": 10.2,
                                                "longitude_northeast": 20.7, "longitude_southwest": 80.9})
    print(f"created address: {response.json()}")
    assert response.status_code == 200
