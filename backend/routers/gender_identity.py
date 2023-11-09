from typing import List

from fastapi import APIRouter, HTTPException
from starlette import status

from backend import services
from backend.models.gender_identity import GenderIdentity
from backend.services.gender_identity import get_gender_identity, get_gender_identities, post_gender_identity
from backend.exceptions.validation_exception import ValidationException
from backend.exceptions.fatal_exception import FatalException
from backend.exceptions.not_found_exception import NotFoundException

router = APIRouter(prefix='/gender-identities', tags=['gender-identities'], responses={404: {"description": "Not found"}})


@router.get("/", tags=['get'], response_model=List[GenderIdentity], status_code=status.HTTP_200_OK)
async def get_gender_identities():
    return services.gender_identity.get_gender_identities()


@router.get('/{gender_identity_id}', tags=['get'], status_code=status.HTTP_200_OK)
async def get_gender_identity(gender_identity_id: int):
    try:
        return services.gender_identity.get_gender_identity(gender_identity_id)
    except NotFoundException as e:
        raise HTTPException(status_code=404, detail=e.message)
    except FatalException as e:
        raise HTTPException(status_code=400, detail=e.message)


@router.post("/", tags=['post'], response_model=GenderIdentity, status_code=status.HTTP_200_OK)
async def post_gender_identity(gender_identity: GenderIdentity):
    try:
        return services.gender_identity.post_gender_identity(gender_identity)
    except ValidationException as e:
        raise HTTPException(status_code=422, detail=e.message)
