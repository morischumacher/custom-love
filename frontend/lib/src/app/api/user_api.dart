import 'dart:convert';
import 'dart:math';

import 'package:frontend/src/app/exceptions/bad_request_exception.dart';
import 'package:frontend/src/app/exceptions/not_found_exception.dart';
import 'package:frontend/src/app/model/factories/user_factory.dart';
import 'package:frontend/src/app/model/user_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/src/config/api_config.dart';
import 'package:logger/logger.dart';

import '../model/user_detailed.dart';
import 'interfaces/paginated_api.dart';

class UserApi extends PaginatedApi<User> {
  final logger = Logger();
  Random random = Random();

  UserApi(http.Client client) : super(client, "users", UserFactory());
  UserApi.url(http.Client client, String urlParams)
      : super(client, "users/$urlParams", UserFactory());

  @override
  UserApi copyWith(String urlParams) => UserApi.url(client, urlParams);

  Future<User> getUser(var id) async {
    final response =
        await super.client.get(Uri.parse('${ApiConfig.baseUrl}/users/$id'));

    if (response.statusCode == 200) {
      var tmp = json.decode(response.body);
      final User user = User.fromJson(tmp);
      return user;
    } else if (response.statusCode == 404) {
      throw NotFoundException("User not found");
    } else if (response.statusCode == 400) {
      throw BadRequestException("Bad request");
    } else {
      throw Exception("Failed to load user");
    }
  }

  Future<UserDetailed> getUserProfile(int id) async {
    final response =
    await super.client.get(Uri.parse('${ApiConfig.baseUrl}/users/profile/$id'));

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      final UserDetailed user = UserDetailed.fromJson(body);
      return user;
    } else if (response.statusCode == 404) {
      throw NotFoundException("User not found");
    } else if (response.statusCode == 400) {
      throw BadRequestException("Bad request");
    } else {
      throw Exception("Failed to load user");
    }
  }

  Future<User> updateUserLocation(
      Position userPosition, var accessToken) async {
    final Map<String, dynamic> body = {
      "latitude": userPosition.latitude,
      "longitude": userPosition.longitude,
    };

    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/users'),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final dynamic jsonItem = json.decode(response.body);
      print(jsonItem);
      final User user = User.fromJson(jsonItem);
      return user;
    } else if (response.statusCode == 404) {
      throw NotFoundException("User not found");
    } else if (response.statusCode == 422) {
      throw BadRequestException("Unprocessable entity");
    } else {
      throw Exception("Failed to load user");
    }
  }

  Future<User> updateUserSwipesLeft(var accessToken) async {
    final Map<String, dynamic> body = {
      "swiped": true,
    };

    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/users'),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final dynamic jsonItem = json.decode(response.body);
      final User user = User.fromJson(jsonItem);
      return user;
    } else if (response.statusCode == 404) {
      throw NotFoundException("User not found");
    } else if (response.statusCode == 422) {
      throw BadRequestException("Unprocessable entity");
    } else {
      throw Exception("Failed to load user");
    }
  }

  Future<User> updateCurrentUserMatchingAlgorithm(var accessToken, int algoId) async {
    final Map<String, dynamic> body = {
      "algo_id": algoId,
    };

    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/users'),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final dynamic jsonItem = json.decode(response.body);
      final User user = User.fromJson(jsonItem);
      return user;
    } else if (response.statusCode == 404) {
      throw NotFoundException("User not found");
    } else if (response.statusCode == 422) {
      throw BadRequestException("Unprocessable entity");
    } else {
      throw Exception("Failed to load user");
    }
  }

  Future<User> getAlgoUser(var accessToken, int algoId) async {
    final response = await http.get(
      Uri.parse(
          '${ApiConfig.baseUrl}/users/algo/{algoId}?algoId=$algoId&page=1&size=50'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final dynamic jsonItem = json.decode(response.body);
      final User user = User.fromJson(jsonItem);
      return user;
    } else if (response.statusCode == 404) {
      throw NotFoundException("User not found");
    } else if (response.statusCode == 400) {
      throw BadRequestException("Bad request");
    } else {
      throw Exception("Failed to load user");
    }
  }
}
