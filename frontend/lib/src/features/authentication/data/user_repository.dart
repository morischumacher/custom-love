import 'dart:convert';

import 'package:frontend/src/features/authentication/domain/user_model.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  final http.Client httpClient;

  UserRepository({required this.httpClient});

  Future<List<User>> getUsers() async {
    final response = await httpClient.get(
        Uri.parse('http://127.0.0.1:8000/user/all')); // TODO: outsource uri

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
}
