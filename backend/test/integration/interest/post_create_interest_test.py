from backend.test.integration.fixtures import client_fixture as client, session_fixture as session

def test_post_create_interest(client, session):
    response = client.post("/interests/", json={"name": "theater", "icon": "icon6"})
    print(f"created interest: {response.json()}")
    assert response.status_code == 200
