from datetime import datetime
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session
from backend.models.preference import Preference



def test_get_all_preferences(client, session):
    preference_1: Preference = Preference(property_1="property1", property_2="property4", decision="decision1",
                                          date=datetime.today())
    preference_2: Preference = Preference(property_1="property2", property_2="property5", decision="decision2",
                                          date=datetime.today())

    session.add(preference_1)
    session.add(preference_2)
    session.commit()

    response = client.get("/preferences/")
    print(f"got preferences: {response.json()}")
    assert response.status_code == 200
