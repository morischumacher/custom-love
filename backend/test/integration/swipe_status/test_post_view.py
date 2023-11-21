from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from integration.swipe_status.get_bearer_token import get_bearer_token
from integration.test_data.test_data import USER_BRAVO, USER_ALFA


def test_post_view(client, session):
    session.add(USER_ALFA)
    session.add(USER_BRAVO)
    session.commit()

    bearer_token = get_bearer_token(f"alfa.alfonson@email.com", "pass1", client)

    swipe_header = {'Authorization': f'Bearer {bearer_token.json()['access_token']}'}
    response = client.post(f'/swipe_statuses/view/{USER_BRAVO.id}', headers=swipe_header)
    assert response.status_code == 200

    bearer_token = get_bearer_token("bravo.bravonson@email.com", "pass1", client)
    swipe_header = {'Authorization': f'Bearer {bearer_token.json()['access_token']}'}
    response = client.post(f'/swipe_statuses/view/{USER_ALFA.id}', headers=swipe_header)
    assert response.status_code == 200

    # Testing to match user to him- or herself
    bearer_token = get_bearer_token("alfa.alfonson@email.com", "pass1", client)

    swipe_header = {'Authorization': f'Bearer {bearer_token.json()['access_token']}'}
    response = client.post(f'/swipe_statuses/view/{USER_ALFA.id}', headers=swipe_header)

    assert response.status_code == 422
    assert response.json()['detail'] == 'User trying to match him- or herself'
