from typing import Union
from fastapi import FastAPI

from backend.repository.repository import create_db
from backend.routers import user

app = FastAPI()
app.include_router(user.router)


@app.on_event("startup")
def on_startup():
    create_db()


@app.get("/health")
def read_root():
    """
    kubernetes liveness probe
    """
    return {"satus": "application_alive"}
