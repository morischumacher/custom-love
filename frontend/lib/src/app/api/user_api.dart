import 'dart:convert';

import 'package:frontend/src/app/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/src/config/api_config.dart';
import 'dart:math';

class UserApi {
  final http.Client httpClient;

  UserApi({required this.httpClient});

  Future<List<User>> getUsers() async {
    final response =
    await httpClient.get(Uri.parse('${ApiConfig.baseUrl}/users'));

    if (response.statusCode == 200) {
      print("RESPONSE: ${response.body}");
      var tmp = json.decode(response.body);
      final List<dynamic> jsonList = tmp["items"];
      final List<User> users =
      jsonList.map((json) => User.fromJson(json)).toList();
      return users;
    } else {
      // TODO: Add custom exception
      throw Exception('Failed to fetch users');
    }

  }

  Future<User> getUser() async {
    Random random = Random();
    int number = random.nextInt(3) + 1;
    final response =
    await httpClient.get(Uri.parse('${ApiConfig.baseUrl}/users/$number'));

    if (response.statusCode == 200) {
      print("RESPONSE: ${response.body}");
      var tmp = json.decode(response.body);
      final User user = User.fromJson(tmp);
      return user;
    } else {
      // TODO: Add custom exception
      throw Exception('Failed to fetch user');
    }

  }

}
