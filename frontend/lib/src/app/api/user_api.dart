import 'dart:convert';

import 'package:frontend/src/app/model/user_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/src/config/api_config.dart';
import 'package:logger/logger.dart';

class UserApi {
  final http.Client httpClient;
  final logger = Logger();

  UserApi({required this.httpClient});

  Future<List<User>> getUsers() async {
    final response =
        await httpClient.get(Uri.parse('${ApiConfig.baseUrl}/users'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final List<User> users =
          jsonList.map((json) => User.fromJson(json)).toList();
      return users;
    } else {
      // TODO: Add custom exception
      throw Exception('Failed to fetch users');
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
}
