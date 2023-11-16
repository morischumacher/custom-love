import argparse
import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from backend.datagenerator.data_generator import DataGenerator
from backend.repository.repository import create_db, get_engine
from backend.routers import user, language, preference, address, rating, match, interest, gender_identity
from fastapi_pagination import add_pagination

app = FastAPI()
add_pagination(app)
app.include_router(user.router)
app.include_router(language.router)
app.include_router(preference.router)
app.include_router(address.router)
app.include_router(rating.router)
app.include_router(match.router)
app.include_router(interest.router)
app.include_router(gender_identity.router)


@app.on_event("startup")
def on_startup():
    create_db()
    data_generator: DataGenerator = DataGenerator(get_engine())
    data_generator.generate_data()


@app.get("/health")
def read_root():
    return {"status": "application_alive"}


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        prog='INSO_06',
        description='INSO_06 project backend')
    parser.add_argument('--production', action='store_true')
    parser.add_argument('--proxy-headers', action='store_true')
    parser.add_argument('--reload', action='store_true')
    parser.add_argument('--host', default="127.0.0.1")
    parser.add_argument('--port', default=8000)
    parser.add_argument('--root-path', default="/")
    args = parser.parse_args()
    print(args.proxy_headers)
    uvicorn.run("backend.main:app", host=args.host, port=int(args.port), root_path=args.root_path, proxy_headers=args.proxy_headers,
                reload=args.reload)
