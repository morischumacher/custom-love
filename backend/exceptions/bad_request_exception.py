from fastapi import HTTPException


class BadRequestException(HTTPException):
    """
    Exception used to signal unexpected and unrecoverable errors.
    """
    def __init__(self, message=""):
        super(BadRequestException, self).__init__(status_code=400, detail=message)
