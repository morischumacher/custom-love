from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.models.gender_identity import GenderIdentity

def test_get_gender_identity_by_id(client, session):
    man = GenderIdentity(name="man")
    woman = GenderIdentity(name="woman")

    session.add(man)
    session.add(woman)
    session.commit()

    response = client.get("/gender-identities/1")
    print(f"got gender-identity: {response.json()}")
    assert response.status_code == 200
