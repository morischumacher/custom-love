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
    /*
    final Map<String, dynamic> body = {
      "first_name": "firstName",
      "last_name": "lastName",
      "email": "email",
      "password": "password",
      "bio": "bio",
      // "date_of_birth": "1955-11-18T11:11:27.137918",
      "date_of_birth": "birthdate",
      "job": "job",
      // "search_radius": 200,
      // "swipes_left": 10,
      "gender_identity_id": "1",
      // "address_id": 2
    };
     */
    final Map<String, String> body = {
      "first_name": "Echo",
      "last_name": "Echoson",
      "email": "echo.echoson@email.con",
      "password": "pass1",
      "bio": "Test subject",
      "date_of_birth": "1975-11-18T11:11:27.137918",
      "job": "Software Engineer",
      "search_radius": 1.toString(),
      "swipes_left": 1.toString(),
      "gender_identity_id": 1.toString(),
      "address_id": 1.toString()
    };

    final String bd = "{\"first_name\": \"Echo\"}";

    print("BODY");
    print(body);
    print("\n");
    print('${ApiConfig.baseUrl}/users/');

    final response = await httpClient.post(
        Uri.parse('${ApiConfig.baseUrl}/users/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(<String, String>{
          "first_name": "Echo",
          "last_name": "Echoson",
          "email": "echo.echoson@email.con",
          "password": "pass1",
          "bio": "Test subject",
          "date_of_birth": "1975-11-18T11:11:27.137918",
          "job": "Software Engineer",
          "search_radius": 1.toString(),
          "swipes_left": 1.toString(),
          "gender_identity_id": 1.toString(),
          "address_id": 1.toString(),
          "swipe_limit_reset_date": 10.toString()
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
