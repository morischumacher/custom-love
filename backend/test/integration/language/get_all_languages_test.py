from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.models.language import Language


def test_get_all_languages(client, session):
    english: Language = Language(id=1, name="English")
    german: Language = Language(id=2, name="German")
    french: Language = Language(id=3, name="French")

    session.add(english)
    session.add(german)
    session.add(french)
    session.commit()

    response = client.get("/languages/")
    print(f"got languages: {response.json()}")
    assert response.status_code == 200