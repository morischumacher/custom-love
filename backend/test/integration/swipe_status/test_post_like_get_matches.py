from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from integration.swipe_status.get_bearer_token import get_bearer_token
from integration.test_data.test_data import USER_BRAVO, USER_ALFA


def test_post_like_get_matches(client, session):
    session.add(USER_ALFA)
    session.add(USER_BRAVO)
    session.commit()

    alfa_token = get_bearer_token("alfa.alfonson@email.com", "pass1", client)
    alfa_swipe_header = {'Authorization': f'Bearer {alfa_token.json()['access_token']}'}
    response = client.post(f'/swipe_statuses/like/{USER_BRAVO.id}', headers=alfa_swipe_header)
    assert response.status_code == 200

    bravo_token = get_bearer_token("bravo.bravonson@email.com", "pass1", client)
    bravo_swipe_header = {'Authorization': f'Bearer {bravo_token.json()['access_token']}'}
    response = client.post(f'/swipe_statuses/like/{USER_ALFA.id}', headers=bravo_swipe_header)
    assert response.status_code == 200

    # Test if match has been stored
    response = client.get(f'/swipe_statuses/matches', headers=alfa_swipe_header)
    assert response.status_code == 200
    assert len(response.json()) == 1
    assert response.json()[0]['status'] == 'match'

    response = client.get(f'/swipe_statuses/matches', headers=bravo_swipe_header)
    assert response.status_code == 200
    assert len(response.json()) == 1
    assert response.json()[0]['status'] == 'match'

    # Test Matching user to him- or herself
    bearer_token = get_bearer_token("alfa.alfonson@email.com", "pass1", client)

    swipe_header = {'Authorization': f'Bearer {bearer_token.json()['access_token']}'}
    response = client.post(f'/swipe_statuses/like/{USER_ALFA.id}', headers=swipe_header)

    assert response.status_code == 422
    assert response.json()['detail'] == 'Cannot match a person with itself'
