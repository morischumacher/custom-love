import 'package:frontend/src/app/api/user_api.dart';
import 'package:frontend/src/app/model/user_model.dart';
import 'package:geolocator/geolocator.dart';

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

  Future<User> updateCurrentUserLocation(
      Position userPosition, var accessToken) async {
    try {
      final updateUser = _userApi.updateUserLocation(userPosition, accessToken);
      return updateUser;
    } on Exception {
      rethrow;
    }
  }
}
