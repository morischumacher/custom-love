import 'package:frontend/src/app/api/user_api.dart';
import 'package:frontend/src/app/model/user_model.dart';
import 'package:frontend/src/app/service/interfaces/paginated_service.dart';
import 'package:geolocator/geolocator.dart';

class UserService extends PaginatedService<User, UserApi> {
  UserService(super._api);

  @override
  PaginatedService<User, UserApi> copyWith(String urlParams)
  => UserService(super.api.copyWith(urlParams));

  Future<List<User>> getAllUsers() async {
    try {
      Map<int, User> users = await super.api.getAll();
      return users.values as List<User>;
    } on Exception {
      rethrow;
    }
  }

  Future<User> getUser() async {
    try {
      final user = super.api.getUser();
      return user;
    } on Exception {
      rethrow;
    }
  }

  Future<User> updateCurrentUserLocation(
      Position userPosition, var accessToken) async {
    try {
      final updateUser = super.api.updateUserLocation(userPosition, accessToken);
      return updateUser;
    } on Exception {
      rethrow;
    }
  }

  Future<User> updateCurrentUserSwipesLeft(var accessToken) async {
    try {
      final updateUser = _userApi.updateUserSwipesLeft(accessToken);
      return updateUser;
    } on Exception {
      rethrow;
    }
  }

  Future<User> getAlgoUser(var accessToken) async {
    try {
      final algoUser = super.api.getAlgoUser(accessToken);
      return algoUser;
    } on Exception {
      rethrow;
    }
  }
}
