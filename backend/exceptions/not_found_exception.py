class NotFoundException(Exception):
    """
    Exception used to signal that a certain object could not be found within the database.
    """
    def __init__(self, message):
        self.message = message
