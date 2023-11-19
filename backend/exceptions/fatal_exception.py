from fastapi import HTTPException


class FatalException(HTTPException):
    """
    Exception used to signal unexpected and unrecoverable errors.
    """
    def __init__(self, message):
        self.message = message
