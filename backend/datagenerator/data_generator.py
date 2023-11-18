from datetime import datetime

from sqlalchemy.engine import Engine
from sqlmodel import Session, select

from backend.models.address import Address
from backend.models.gender_identity import GenderIdentity
from backend.models.interest import Interest
from backend.models.language import Language
from backend.models.preference import Preference
from backend.models.rating import Rating
from backend.models.swipe_status import SwipeStatus, SwipeStatusType
from backend.models.user import User
from backend.security.passwords import hash_pwd


class DataGenerator:
    def __init__(self, engine: Engine):
        self.engine = engine

    def generate_data(self):
        with Session(self.engine) as session:
            if len(session.exec(select(Language)).all()) == 0 and len(session.exec(select(Language)).all()) == 0:
                print("Generating data")
                self.__generate_users()
            else:
                print("Data already generated")

    # TODO: Modularize Languages, Preferences etc.
    def __generate_users(self):
        with Session(self.engine) as session:
            # Languages
            english: Language = Language(name="English")
            german: Language = Language(name="German")
            french: Language = Language(name="French")

            # Preferences
            preference_1: Preference = Preference(property_1="property1", property_2="property4", decision="decision1",
                                                  date=datetime.today())
            preference_2: Preference = Preference(property_1="property2", property_2="property5", decision="decision2",
                                                  date=datetime.today())

            # Addresses
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

            # Gender Identity
            man = GenderIdentity(name="man")
            woman = GenderIdentity(name="woman")
            divers = GenderIdentity(name="divers")

            # Interest
            sports = Interest(name="sports", icon="icon1")
            movies = Interest(name="movies", icon="icon2")
            travel = Interest(name="travel", icon="icon3")
            books = Interest(name="books", icon="icon4")
            science = Interest(name="science", icon="icon5")

            # Users
            user_alfa = User(
                first_name='Alfa',
                last_name='Alfonson',
                email='alfa.alfonson@email.com',
                bio='Test subject',
                date_of_birth=datetime.today(),
                job='Software Engineer',
                search_radius=200,
                swipes_left=10,
                languages=[english],
                preferences=[preference_1],
                gender_preferences=[woman],
                address=vienna,
                gender_identity=man,
                interests=[sports, movies],
                password=hash_pwd("pass1")
            )
            user_bravo = User(
                first_name='Bravo',
                last_name='Bravonson',
                email='bravo.bravonson@email.com',
                bio='Test subject 2',
                date_of_birth=datetime.today(),
                job='Data Scientist',
                search_radius=50,
                swipes_left=5,
                languages=[english, french, german],
                preferences=[preference_1, preference_2],
                gender_preferences=[woman, man],
                address=ulm,
                gender_identity=woman,
                interests=[travel, books, science],
                password=hash_pwd("pass1")
            )
            user_charlie = User(
                first_name='Charlie',
                last_name='Charlieson',
                email='charlie.charlieson@email.com',
                bio='Test subject 3',
                date_of_birth=datetime.today(),
                job='Civil Engineer',
                search_radius=20,
                swipes_left=2,
                languages=[french, german],
                gender_preferences=[woman],
                preferences=[preference_2],
                address=ulm,
                gender_identity=divers,
                interests=[science],
                password=hash_pwd("pass1")
            )

            # Rating
            alfa_bravo_rating = Rating(id=1, rating_user_id=user_alfa.id, rated_user_id=user_bravo.id, is_safe=True)

            #Match
            alfa_bravo_matching = SwipeStatus(user1_id=user_alfa.id, user2_id=user_bravo.id, status=SwipeStatusType.match)
            alfa_charlie_matching = SwipeStatus(user1_id=user_alfa.id, user2_id=user_charlie.id, status=SwipeStatusType.view)

            session.add(user_alfa)
            session.add(user_bravo)
            session.commit()

            session.refresh(user_alfa)
            session.refresh(user_bravo)

            session.add(alfa_bravo_rating)
            session.add(alfa_bravo_matching)
            session.add(alfa_charlie_matching)
            session.add(alfa_charlie_matching)
            session.commit()
            session.refresh(alfa_bravo_rating)
            session.refresh(alfa_bravo_matching)
            session.refresh(alfa_charlie_matching)
            session.refresh(alfa_charlie_matching)
