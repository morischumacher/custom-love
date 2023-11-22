from fastapi.testclient import TestClient
from sqlmodel import Session
from starlette import status
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.test.integration.test_utils import load_entities, user_alfa, user_beta


def test_get_users(client: TestClient, session: Session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    response = client.get("/users")

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['total'] == 2
    assert response.json()['items'][0]['id'] == users[0].id
    assert response.json()['items'][1]['id'] == users[1].id
