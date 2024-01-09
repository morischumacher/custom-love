from sqlmodel import Session
from starlette import status
from starlette.testclient import TestClient

from backend.models.conversation import Conversation
from backend.models.image import ProfilePicture
from backend.test.integration.test_utils import user_alfa, user_beta
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.test.integration.test_utils import load_entities, user_alfa, user_beta, authorized_request, login, \
    RAW_PASSWORD


def test_get_profile_picture_non_existent(client: TestClient, session: Session):
    users = [user_alfa()]
    load_entities(users, session)

    token = login(users[0].email, RAW_PASSWORD, client)
    response = authorized_request(token, client, lambda c: c.get, "/profile-picture?picture_id=1")

    assert response.status_code == status.HTTP_404_NOT_FOUND


def test_get_profile_picture_unauthorized(client: TestClient, session: Session):
    users = [user_alfa(), user_beta()]
    load_entities(users, session)

    picture = ProfilePicture(
        user_id=users[0].id,
        content=b'12345',
        filename="test.jpg",
        content_type="image/jpeg"
    )
    load_entities([picture], session)

    token = login(users[1].email, RAW_PASSWORD, client)
    response = authorized_request(token, client, lambda c: c.get, "/profile-picture?picture_id=1")

    assert response.status_code == status.HTTP_401_UNAUTHORIZED


def test_get_profile_picture(client: TestClient, session: Session):
    users = [user_alfa()]
    load_entities(users, session)

    picture = ProfilePicture(
        user_id=users[0].id,
        content=b'12345',
        filename="test.jpg",
        content_type="image/jpeg"
    )
    load_entities([picture], session)

    token = login(users[0].email, RAW_PASSWORD, client)
    response = authorized_request(token, client, lambda c: c.get, "/profile-picture?picture_id=1")

    assert response.status_code == status.HTTP_200_OK


def test_get_profile_pictures(client: TestClient, session: Session):
    users = [user_alfa()]
    load_entities(users, session)

    pictures = [
        ProfilePicture(
            user_id=users[0].id,
            content=b'1',
            filename="test1.jpg",
            content_type="image/jpeg"
        ),
        ProfilePicture(
            user_id=users[0].id,
            content=b'12',
            filename="test2.jpg",
            content_type="image/jpeg"
        ),
    ]
    load_entities(pictures, session)

    token = login(users[0].email, RAW_PASSWORD, client)
    response = authorized_request(token, client, lambda c: c.get, "/profile-picture")

    assert response.status_code == status.HTTP_200_OK
    assert response.json()[0] == pictures[0].id
    assert response.json()[1] == pictures[1].id
