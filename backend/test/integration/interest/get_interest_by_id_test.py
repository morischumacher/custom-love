from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.models.interest import Interest


def test_get_interest_by_id(client, session):
    sports = Interest(name="sports", icon="icon1")
    movies = Interest(name="movies", icon="icon2")
    travel = Interest(name="travel", icon="icon3")

    session.add(sports)
    session.add(movies)
    session.add(travel)
    session.commit()

    response = client.get("/interests/3")
    print(f"got interest: {response.json()}")
    assert response.status_code == 200
