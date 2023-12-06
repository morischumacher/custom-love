import 'dart:convert';
import 'dart:math';

import 'package:frontend/src/app/api/helpers/pagination_api.dart';
import 'package:frontend/src/app/model/factories/user_factory.dart';
import 'package:frontend/src/app/model/user_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/src/config/api_config.dart';
import 'package:logger/logger.dart';

import 'interfaces/paginated_api.dart';

class UserApi extends PaginatedApi<User> {
  final logger = Logger();
  Random random = Random();

  UserApi(http.Client client): super(client, "users/", UserFactory());
  UserApi.url(http.Client client, String urlParams): super(client, "users/$urlParams", UserFactory());


  @override
  UserApi copyWith(String urlParams) =>
      UserApi.url(
          client,
          urlParams
      );

  Future<User> getUser(var id) async {
    final response =
    await super.client.get(Uri.parse('${ApiConfig.baseUrl}/users/$id'));

    if (response.statusCode == 200) {
      var tmp = json.decode(response.body);
      final User user = User.fromJson(tmp);
      return user;
    } else {
      // TODO: Add custom exception
      throw Exception('Failed to fetch user');
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
      final User user = User.fromJson(jsonItem);
      return user;
    } else {
      // TODO: Add custom exception
      throw Exception('Failed to update user');
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
    } else {
      // TODO: Add custom exception
      throw Exception('Failed to update user swipesLeft');
    }
  }

  Future<User> getAlgoUser(var accessToken, int algoId) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/users/algo/$algoId?algoId=1&page=1&size=50'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    print("fetched user: " + response.body);

    if (response.statusCode == 200) {
      final dynamic jsonItem = json.decode(response.body);
      final User user = User.fromJson(jsonItem);
      return user;
    } else {
      // TODO: Add custom exception
      throw Exception('Failed to fetch algo user');
    }
  }
}
