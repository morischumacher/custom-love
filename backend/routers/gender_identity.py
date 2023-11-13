from typing import List, Annotated

from fastapi import APIRouter, Depends
from starlette import status

from backend.models.gender_identity import GenderIdentity
from backend.services.gender_identity import get_gender_identity, get_gender_identities, post_gender_identity

router = APIRouter(prefix='/gender-identities', tags=['gender-identities'], responses={404: {"description": "Not found"}})


@router.get("/", response_model=List[GenderIdentity], status_code=status.HTTP_200_OK)
async def get_gender_identities(commons: Annotated[dict, Depends(get_gender_identities)]):
    return commons


@router.get('/{gender_identity_id}', tags=['get'], response_model=GenderIdentity, status_code=status.HTTP_200_OK)
def get_gender_identity(commons: Annotated[dict, Depends(get_gender_identity)]):
    return commons


@router.post('/', tags=['post'], status_code=status.HTTP_200_OK)
def post_gender_identity(gender_identity: GenderIdentity, commons: Annotated[dict, Depends(post_gender_identity)]):
    return commons
