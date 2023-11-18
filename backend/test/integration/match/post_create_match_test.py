from datetime import datetime

from backend.models.address import Address
from backend.models.gender_identity import GenderIdentity
from backend.models.interest import Interest
from backend.models.language import Language
from backend.models.preference import Preference
from backend.models.user import User
from backend.test.integration.fixtures import client_fixture as client, session_fixture as session

def test_post_create_match(client, session):
    english: Language = Language(name="English")
    german: Language = Language(name="German")
    french: Language = Language(name="French")

    preference_1: Preference = Preference(property_1="property1", property_2="property4", decision="decision1",
                                          date=datetime.today())
    preference_2: Preference = Preference(property_1="property2", property_2="property5", decision="decision2",
                                          date=datetime.today())

    ulm: Address = Address(
        country="Germany",
        city="Ulm",
        district="Kesselbronn",
        latitude_northeast=2.1,
        latitude_southwest=10.2,
        longitude_northeast=20.7,
        longitude_southwest=80.9
    )
    vienna: Address = Address(
        country="Austria",
        city="Vienna",
        district="10",
        latitude_northeast=39.4,
        latitude_southwest=30.2,
        longitude_northeast=23.2,
        longitude_southwest=65.0
    )

    man = GenderIdentity(name="man")
    woman = GenderIdentity(name="woman")

    sports = Interest(name="sports", icon="icon1")
    movies = Interest(name="movies", icon="icon2")
    travel = Interest(name="travel", icon="icon3")
    books = Interest(name="books", icon="icon4")
    science = Interest(name="science", icon="icon5")

    user_alfa = User(
        first_name='Alfa',
        last_name='Alfonson',
        email='alfa.alfonson@email.com',
        tel='+43 231 472 941',
        bio='Test subject',
        date_of_birth=datetime.today(),
        job='Software Engineer',
        search_radius=200,
        swipes_left=10,
        languages=[english],
        gender_preferences=[woman],
        preferences=[preference_2],
        address=vienna,
        gender_identity=woman,
        interests=[sports, movies],
        password="pass1"
    )
    user_bravo = User(
        first_name='Bravo',
        last_name='Bravonson',
        email='bravo.bravonson@email.com',
        tel='+92 231 023 953',
        bio='Test subject 2',
        date_of_birth=datetime.today(),
        job='Data Scientist',
        search_radius=50,
        swipes_left=5,
        languages=[english, french, german],
        gender_preferences=[man, woman],
        preferences=[preference_1],
        address=ulm,
        gender_identity=woman,
        interests=[travel, books, science],
        password="pass1"
    )

    session.add(user_bravo)
    session.add(user_alfa)
    session.commit()

    response = client.post("/matches/",
                           json={"match_user1_id": user_alfa.id, "match_user2_id": user_bravo.id, "is_match": True})
    print(f"created match: {response.json()}")
    assert response.status_code == 200
