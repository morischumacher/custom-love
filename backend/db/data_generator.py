from sqlmodel import Session
from db.models import User


class DataGenerator:
    def __init__(self, session: Session):
        self.session = session

    def generate_data(self):
        print("Generating data")
        self.__generate_users()

    def __generate_users(self):
        print(" * Generating users")
        user_alfa = User(
            first_name='Alfa',
            last_name='Alfonson',
            email='alfa.alfonson@email.com',
            tel='+43 231 472 941',
            bio='Test subject',
            job='Software Engineer'
        )
        self.session.add(user_alfa)
        self.session.commit()
