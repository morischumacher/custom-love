class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException(this.message);
}

class WrongPasswordException implements Exception {
  final String message = "Wrong Password";

  WrongPasswordException();
}

class WrongEmailException implements Exception {
  final String message = "Wrong Email";

  WrongEmailException();
}
