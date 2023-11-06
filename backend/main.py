from typing import Union, List
from fastapi import FastAPI, status
from sqlmodel import Session,select
from sqlmodel.sql.expression import SelectOfScalar

from db.data_generator import DataGenerator
from db.database import engine, create_db_and_tables
from db.models import User

app = FastAPI()

session=Session(bind=engine)

create_db_and_tables()

data_generator: DataGenerator = DataGenerator(session)
data_generator.generate_data()


@app.get("/")
def read_root():
    return {"Hello": "World"}


@app.get("/health")
def read_root():
    return {"status": "application_alive"}


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}


@app.get("/users", response_model=List[User], status_code=status.HTTP_200_OK)
async def get_users():
    """
        user_alfa = User(
            first_name='Alfa',
            last_name ='Alfonson',
            email='alfa.alfonson@email.com',
            tel='+43 231 472 941',
            bio='Test subject',
            job='Software Engineer'
        )
        session.add(user_alfa)
        session.commit()
    """
    statement: SelectOfScalar[User] = select(User)
    users: list[User] = session.exec(statement).all()

    return users
