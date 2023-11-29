from datetime import datetime
from sqlalchemy.engine import Engine
from sqlmodel import Session, select
from backend.models.conversation import Conversation
from backend.models.gender_identity import GenderIdentity
from backend.models.interest import Interest
from backend.models.language import Language
from backend.models.message import Message
from backend.models.preference import Preference
from backend.models.rating import Rating
from backend.models.swipe_status import SwipeStatus, SwipeStatusType
from backend.models.user import User
from backend.utils.passwords import hash_pwd


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
                gender_identity=man,
                interests=[sports, movies],
                password=hash_pwd("pass1"),
                latitude=48.227982,
                longitude=16.372316
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
                gender_identity=woman,
                interests=[travel, books, science],
                password=hash_pwd("pass1"),
                latitude=48.215178,
                longitude=16.354447
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
                gender_identity=divers,
                interests=[science],
                password=hash_pwd("pass1"),
                latitude=48.172097,
                longitude=16.294326
            )
            user4 = User(
                first_name='user4_name',
                last_name='user4_last_name',
                email='user4@email.com',
                bio='Test subject 4',
                date_of_birth=datetime.today(),
                job='Civil Engineer',
                search_radius=20,
                swipes_left=2,
                languages=[french, german],
                gender_preferences=[woman],
                preferences=[preference_2],
                gender_identity=divers,
                interests=[science],
                password=hash_pwd("pass1"),
                latitude=48.172097,
                longitude=16.294326
            )

            users = []
            for i in range(25):
                users.append(User(
                    first_name=f"{chr(i + 65)}",
                    last_name=f"{chr(90 - i)}",
                    email=f"{chr(i + 41)}{chr(90 - i)}@email.com",
                    bio=f'Test subject {i}',
                    date_of_birth=datetime.today(),
                    job='Civil Engineer',
                    search_radius=20,
                    swipes_left=2,
                    languages=[french, german],
                    gender_preferences=[woman],
                    preferences=[preference_2],
                    gender_identity=divers,
                    interests=[science],
                    password=hash_pwd("pass1"),
                    latitude=48.172097,
                    longitude=16.294326
                ))

            # Rating
            alfa_bravo_rating = Rating(id=1, rating_user_id=user_alfa.id, rated_user_id=user_bravo.id, is_safe=True)

            session.add(user_alfa)
            session.add(user_bravo)
            session.commit()

            session.refresh(user_alfa)
            session.refresh(user_bravo)

            # Conversations
            session.add(Conversation(user1_id=user_alfa.id, user2_id=user_bravo.id))
            session.add(Conversation(user1_id=user_charlie.id, user2_id=user_bravo.id))
            session.add(Conversation(user1_id=user_charlie.id, user2_id=user_alfa.id))
            session.add(SwipeStatus(user1_id=user_alfa.id, user2_id=user_bravo.id, status=SwipeStatusType.match))
            session.add(SwipeStatus(user1_id=user_alfa.id, user2_id=user_charlie.id, status=SwipeStatusType.match))
            session.add(SwipeStatus(user1_id=user_bravo.id, user2_id=user_charlie.id, status=SwipeStatusType.match))
            session.add(SwipeStatus(user1_id=user_alfa.id, user2_id=user4.id, status=SwipeStatusType.match))
            session.commit()

            # Rating
            alfa_bravo_rating = Rating(rating_user_id=user_alfa.id, rated_user_id=user_bravo.id, is_safe=True)
            session.add(alfa_bravo_rating)
            session.add(alfa_bravo_rating)
            session.commit()
            session.refresh(alfa_bravo_rating)

            for user in users:
                session.add(user)
                session.commit()
                session.refresh(user)
                session.add(SwipeStatus(user1_id=user_alfa.id, user2_id=user.id, status=SwipeStatusType.match))
                session.commit()

            conversations = []

            for i in range(10):
                user = users[i]
                c = Conversation(user1_id=user.id, user2_id=user_alfa.id)
                conversations.append(c)
                session.add(c)
                session.commit()
                session.refresh(c)

            for c in conversations:
                session.add(Message(conversation_id=c.id, sender_id=c.user1_id, receiver_id=c.user2_id, message=f"Hi user with id: {c.user2_id}", timestamp=datetime.now()))
                session.commit()