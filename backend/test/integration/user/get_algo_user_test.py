from starlette import status

from backend.test.integration.fixtures import postgis_client_fixture as postgis_client, \
    postgis_session_fixture as postgis_session
from backend.test.integration.test_utils import user_alfa, user_beta, user_theater, load_entities, RAW_PASSWORD, login, \
    authorized_request, create_expert_system


def test_get_random_algo_user(postgis_client, postgis_session):
    user_a = user_alfa()
    user_b = user_beta()

    users = [user_a, user_b]
    load_entities(users, postgis_session)

    token = login(user_a.email, RAW_PASSWORD, postgis_client)
    response = authorized_request(token, postgis_client, lambda c: c.get, "/users/algo/{algoId}?algoId=1")

    assert response.status_code == status.HTTP_200_OK


def test_get_interest_based_user(postgis_client, postgis_session):
    user_a = user_alfa()
    user_b = user_beta()
    user_t = user_theater()

    users = [user_a, user_b, user_t]
    load_entities(users, postgis_session)

    token = login(user_a.email, RAW_PASSWORD, postgis_client)
    response = authorized_request(token, postgis_client, lambda c: c.get, "/users/algo/{algoId}?algoId=2")

    assert response.status_code == status.HTTP_200_OK

    actual_user_id = int(response.json()['id'])
    expected_user_id = user_t.id

    assert actual_user_id is expected_user_id


def test_get_preference_based_user(postgis_client, postgis_session):
    user_a = user_alfa()
    user_b = user_beta()
    user_t = user_theater()

    users = [user_a, user_t, user_b]
    load_entities(users, postgis_session)
    create_expert_system(user_a.id, postgis_session)

    token = login(user_a.email, RAW_PASSWORD, postgis_client)
    response = authorized_request(token, postgis_client, lambda c: c.get, "/users/algo/{algoId}?algoId=3")

    assert response.status_code == status.HTTP_200_OK

    actual_user_id = int(response.json()['id'])
    expected_user_id = user_b.id

    assert actual_user_id is expected_user_id
