from datetime import datetime

from backend.models.address import Address
from backend.models.gender_identity import GenderIdentity
from backend.models.interest import Interest
from backend.models.language import Language
from backend.models.preference import Preference
from backend.models.user import User
from backend.security.passwords import hash_pwd

ENGLISH: Language = Language(name="English")
GERMAN: Language = Language(name="German")
FRENCH: Language = Language(name="French")

PREFERENCE_1: Preference = Preference(property_1="property1", property_2="property4", decision="decision1",
                                      date=datetime.today())
PREFERENCE_2: Preference = Preference(property_1="property2", property_2="property5", decision="decision2",
                                      date=datetime.today())

ULM: Address = Address(
    country="Germany",
    city="Ulm",
    district="Kesselbronn",
    latitude_northeast=2.1,
    latitude_southwest=10.2,
    longitude_northeast=20.7,
    longitude_southwest=80.9
)
VIENNA: Address = Address(
    country="Austria",
    city="Vienna",
    district="10",
    latitude_northeast=39.4,
    latitude_southwest=30.2,
    longitude_northeast=23.2,
    longitude_southwest=65.0
)

MAN = GenderIdentity(name="man")
WOMAN = GenderIdentity(name="woman")

SPORTS = Interest(name="sports", icon="icon1")
MOVIES = Interest(name="movies", icon="icon2")
TRAVEL = Interest(name="travel", icon="icon3")
BOOKS = Interest(name="books", icon="icon4")
SCIENCE = Interest(name="science", icon="icon5")

USER_ALFA = User(
    first_name='Alfa',
    last_name='Alfonson',
    email='alfa.alfonson@email.com',
    tel='+43 231 472 941',
    bio='Test subject',
    date_of_birth=datetime.today(),
    job='Software Engineer',
    search_radius=200,
    swipes_left=10,
    languages=[ENGLISH],
    gender_preferences=[WOMAN],
    preferences=[PREFERENCE_2],
    address=VIENNA,
    gender_identity=WOMAN,
    interests=[SPORTS, MOVIES],
    password=hash_pwd("pass1")
)
USER_BRAVO = User(
    first_name='Bravo',
    last_name='Bravonson',
    email='bravo.bravonson@email.com',
    tel='+92 231 023 953',
    bio='Test subject 2',
    date_of_birth=datetime.today(),
    job='Data Scientist',
    search_radius=50,
    swipes_left=5,
    languages=[ENGLISH, FRENCH, GERMAN],
    gender_preferences=[MAN, WOMAN],
    preferences=[PREFERENCE_1],
    address=ULM,
    gender_identity=WOMAN,
    interests=[TRAVEL, BOOKS, SCIENCE],
    password=hash_pwd("pass1")
)
