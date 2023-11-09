class ValidationException(Exception):
    """
    Exception that signals, that data, that came from outside the backend, is invalid.
    The data violates some invariant constraint (rather than one, that is imposed by the current data in the system).
    Contains a list of all validations that failed when validating the piece of data in question.
    """
    def __init__(self, message):
        self.message = message
