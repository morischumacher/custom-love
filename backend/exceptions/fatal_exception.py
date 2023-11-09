class FatalException(Exception):
    """
    Exception used to signal unexpected and unrecoverable errors.
    """
    def __init__(self, message):
        self.message = message
