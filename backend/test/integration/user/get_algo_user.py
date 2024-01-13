from starlette import status

from backend.test.integration.fixtures import postgis_client_fixture as postgis_client, postgis_session_fixture as postgis_session
from backend.test.integration.test_utils import user_alfa, user_beta, load_entities, RAW_PASSWORD, login, \
    authorized_request


def test_get_algo_user(postgis_client, postgis_session):
    users = [user_alfa(), user_beta()]
    load_entities(users, postgis_session)

    token = login(users[0].email, RAW_PASSWORD, postgis_client)
    response = authorized_request(token, postgis_client, lambda c: c.get, "/users/algo/{algoId}?algoId=1")

    assert response.status_code == status.HTTP_200_OK
