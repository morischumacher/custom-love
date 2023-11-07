from sqlalchemy.engine import Engine
from sqlmodel import Session
from backend.models.user import User


class DataGenerator:
    def __init__(self, engine: Engine):
        self.engine = engine

    def generate_data(self):
        print("Generating data")
        self.__generate_users()

    def __generate_users(self):
        with Session(self.engine) as session:
            print(" * Generating users")
            user_alfa = User(
                first_name='Alfa',
                last_name='Alfonson',
                email='alfa.alfonson@email.com',
                tel='+43 231 472 941',
                bio='Test subject',
                job='Software Engineer'
            )
            session.add(user_alfa)
            session.commit()
