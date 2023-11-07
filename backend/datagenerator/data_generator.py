from datetime import datetime

from sqlalchemy.engine import Engine
from sqlmodel import Session, select

from backend.models.language import Language
from backend.models.user import User


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

    def __generate_users(self):
        with Session(self.engine) as session:
            english: Language = Language(name="English")
            german: Language = Language(name="German")
            french: Language = Language(name="French")

            print(" * Generating users")
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
                languages=[english]
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
                languages=[english, french, german]
            )
            session.add(user_alfa)
            session.add(user_bravo)
            session.commit()

            session.refresh(user_alfa)
            session.refresh(user_bravo)
