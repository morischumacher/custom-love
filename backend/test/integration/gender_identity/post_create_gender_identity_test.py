from backend.test.integration.fixtures import client_fixture as client, session_fixture as session

def test_post_create_gender_identity(client, session):
    response = client.post("/gender-identities/",
                           json={"name": "divers"})
    print(f"created gender-identity: {response.json()}")
    assert response.status_code == 200