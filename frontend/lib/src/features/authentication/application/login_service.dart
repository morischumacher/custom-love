import 'package:frontend/src/config/exceptions.dart';
import 'package:frontend/src/features/authentication/api/login_repository.dart';

class LoginService {
  final LoginRepository _loginRepository;

  LoginService(this._loginRepository);

  Future<Map<String, dynamic>> loginTo(email, password) async {
    try {
      final body = _loginRepository.loginUser(email, password);
      return body;
    } catch (e) {
      rethrow;
    }
  }
}
