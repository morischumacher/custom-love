import 'package:frontend/src/features/authentication/domain/user_model.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  final http.Client httpClient;

  UserRepository({required this.httpClient});

  Future<List<User>> getUsers() async {
    final response = await httpClient.get(Uri.parse('https://www.google.com/'));

    if (response.statusCode == 200) {
      print("Get Users successful");
      return [];
    } else {
      // TODO: Add custom exception
      throw Exception('Failed to fetch users');
    }
  }
}
