from sqlmodel import Session
from starlette import status
from starlette.testclient import TestClient

from backend.models.swipe_status import SwipeStatus, SwipeStatusType
from backend.test.integration.test_utils import user_alfa, user_beta, load_entities, RAW_PASSWORD, login, \
    authorized_request
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session


def test_get_matches(client: TestClient, session: Session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    match = SwipeStatus(user1_id=users[0].id, user2_id=users[1].id, status=SwipeStatusType.match)
    load_entities([match], session)

    user1_token = login(users[0].email, RAW_PASSWORD, client)
    response = authorized_request(user1_token, client, lambda c: c.get, f'/swipe_statuses/matches')

    assert response.status_code == status.HTTP_200_OK
    assert response.json()['total'] == 1
    assert response.json()['items'][0]['id'] == match.id
