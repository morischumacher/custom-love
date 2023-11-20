from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.models.gender_identity import GenderIdentity


def test_get_all_gender_identities(client, session):
    man = GenderIdentity(name="man")
    woman = GenderIdentity(name="woman")

    session.add(man)
    session.add(woman)
    session.commit()

    response = client.get("/gender-identities/")
    print(f"got gender-identities: {response.json()}")
    assert response.status_code == 200