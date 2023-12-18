import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/src/config/api_config.dart';

class RegistrationApi {
  final http.Client httpClient;

  RegistrationApi({required this.httpClient});

  Future<Map<String, dynamic>> registerUser(
      String firstName,
      String lastName,
      String email,
      String password,
      String bio,
      String birthdate,
      String job,
      int genderIdentityId
      ) async {
    final response = await httpClient.post(
        Uri.parse('${ApiConfig.baseUrl}/users/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(<String, String>{
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "password": password,
          "bio": "",
          "date_of_birth": birthdate,
          "job": "",
          "search_radius": "",
          "swipes_left": "",
          "gender_identity_id": genderIdentityId.toString(),
          "address_id": "",
          "swipe_limit_reset_date": ""
        })
    );

    if (response.statusCode == 200) {
      // Successful login, return the response body as a map
      return json.decode(response.body);
      // TODO: Add all types of possible exceptions
    } else {
      print(response.body);
      throw Exception('Error during Authentication');
    }
  }
}
