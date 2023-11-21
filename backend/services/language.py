from typing import Annotated
from fastapi import Depends
from fastapi_pagination import Params
from fastapi_pagination.ext.sqlmodel import paginate
from sqlmodel import Session, select
from starlette.requests import Request
from backend.models.language import Language
from backend.repository.repository import create_session


def get_languages(db: Annotated[Session, Depends(create_session)], request: Request):
    """
    Return a list of all languages
    :return: a list of all languages
    """
    return paginate(db, select(Language), Params(size=request.query_params.get("size"),
                                                 page=request.query_params.get("page")))
