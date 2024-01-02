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

      List<User> res = [];
      for (var user in users.values) {
        res.add(user);
      }
      return res;
    } on Exception {
      rethrow;
    }
  }

  Future<User> getUser(var id) async {
    try {
      final user = super.api.getUser(id);
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
      final updateUser = super.api.updateUserSwipesLeft(accessToken);
      return updateUser;
    } on Exception {
      rethrow;
    }
  }

  Future<User> updateCurrentUserMatchingAlgorithm(var accessToken, int algoId) async {
    try {
      final updateUser = super.api.updateCurrentUserMatchingAlgorithm(accessToken, algoId);
      return updateUser;
    } on Exception {
      rethrow;
    }
  }

  Future<User> getAlgoUser(var accessToken, int algoId) async {
    try {
      final algoUser = super.api.getAlgoUser(accessToken, algoId);
      return algoUser;
    } on Exception {
      rethrow;
    }
  }

  Future<String> updateExpertSystem(var accessToken) async {
    try {
      final updateExSys = super.api.updateExpertSystem(accessToken);
      return updateExSys;
    } on Exception {
      rethrow;
    }
  }
}
