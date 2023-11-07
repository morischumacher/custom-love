from fastapi import FastAPI

from backend.datagenerator.data_generator import DataGenerator
from backend.repository.repository import create_db, get_engine
from backend.routers import user

app = FastAPI()
app.include_router(user.router)


@app.on_event("startup")
def on_startup():
    create_db()
    data_generator: DataGenerator = DataGenerator(get_engine())
    data_generator.generate_data()


@app.get("/health")
def read_root():
    """
    kubernetes liveness probe
    """
    return {"status": "application_alive"}
