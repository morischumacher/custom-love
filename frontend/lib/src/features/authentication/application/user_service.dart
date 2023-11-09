import 'package:frontend/src/features/authentication/data/user_repository.dart';
import 'package:frontend/src/features/authentication/domain/user_model.dart';

class UserService {
  final UserRepository _userRepository;

  UserService(this._userRepository);

  Future<List<User>> getAllUsers() async {
    try {
      final users = _userRepository.getUsers();
      return users;
    } on Exception catch (e) {
      rethrow;
    }
  }
}
