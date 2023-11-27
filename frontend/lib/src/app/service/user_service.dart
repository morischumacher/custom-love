import 'package:frontend/src/app/api/user_api.dart';
import 'package:frontend/src/app/model/user_model.dart';

class UserService {
  final UserApi _userApi;

  UserService(this._userApi);

  Future<List<User>> getAllUsers() async {
    try {
      final users = _userApi.getUsers();
      return users;
    } on Exception {
      rethrow;
    }
  }

  Future<User> getUser() async {
      try {
        final user = _userApi.getUser();
        return user;
      } on Exception {
        rethrow;
      }
  }

}
