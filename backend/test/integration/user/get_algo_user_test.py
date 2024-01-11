from starlette import status

from backend.test.integration.fixtures import postgis_client_fixture as postgis_client, \
    postgis_session_fixture as postgis_session
from backend.test.integration.test_utils import user_alfa, user_beta, user_theater, load_entities, RAW_PASSWORD, login, \
    authorized_request


def test_get_random_algo_user(postgis_client, postgis_session):
    users = [user_alfa(), user_beta()]
    load_entities(users, postgis_session)

    token = login(users[0].email, RAW_PASSWORD, postgis_client)
    response = authorized_request(token, postgis_client, lambda c: c.get, "/users/algo/{algoId}?algoId=1")

    assert response.status_code == status.HTTP_200_OK


def test_get_interest_based_user(postgis_client, postgis_session):
    users = [user_alfa(), user_theater(), user_beta()]
    load_entities(users, postgis_session)

    token = login(users[0].email, RAW_PASSWORD, postgis_client)
    response = authorized_request(token, postgis_client, lambda c: c.get, "/users/algo/{algoId}?algoId=2")

    assert response.status_code == status.HTTP_200_OK

    actual_user_id = int(response.json()['id'])
    expected_user_id = user_theater().id

    assert actual_user_id is expected_user_id


def test_get_preference_based_user(postgis_client, postgis_session):
    # TODO: Write preferenced based test cases
    pass
