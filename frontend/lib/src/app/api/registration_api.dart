import 'dart:convert';
import 'package:frontend/src/config/exceptions.dart';
import 'package:geolocator/geolocator.dart';
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
      int searchRadius,
      int swipesLeft,
      int genderIdentityId,
      String swipeLimitResetDate
      ) async {
    print("POSTING THE FOLLOWING BODY");
    print('"first_name: " $firstName');
    print('"last_name: " $lastName');
    print('"email: " $email');
    print('"password: " $password');
    print('"bio: " $bio');
    print('"date_of_birth: " $birthdate');
    print('"job: " $job');
    print('"search_radius: " $searchRadius');
    print('"swipes_left: " $swipesLeft');
    print('"gender_identity_id: " $genderIdentityId');
    print('"swipe_limit_reset_date": $swipeLimitResetDate');

    var testing_body = json.encode(<String, String>{
      "first_name": "Juliett",
      "last_name": "Juliettson",
      "email": "juliett@email.com",
      "password": "pass1",
      "bio": "Student and Employee",
      "date_of_birth": "1955-11-18T11:11:27.137918",
      "job": "Software Engineer",
      "search_radius": 10.toString(),
      "swipes_left": 10.toString(),
      "gender_identity_id": 1.toString(),
      "swipe_limit_reset_date": "2024-11-18T11:11:27.137918",
      "longitude": 45.0.toString(),
      "latitude": 45.0.toString(),
      "position": Position(
    longitude: 20.0,
    latitude: 20.0,
    accuracy: 20.0,
    timestamp: DateTime.now(),
    altitude: 20.0,
    altitudeAccuracy: 20.0,
    heading: 20.0,
    headingAccuracy: 20.0,
    speed: 20.0,
    speedAccuracy: 20.0
    ).toString()
    });

    final response = await httpClient.post(
        Uri.parse('${ApiConfig.baseUrl}/users/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: testing_body
    );

    /*
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
          "bio": bio,
          "date_of_birth": birthdate,
          "job": job,
          "search_radius": searchRadius.toString(),
          "swipes_left": swipesLeft.toString(),
          "gender_identity_id": genderIdentityId.toString(),
          "swipe_limit_reset_date": swipeLimitResetDate
        })
    );
     */

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 422) {
      throw InvalidRegistrationInputsException();
    } else {
      print(response.body);
      throw Exception('Error during Registration');
    }
  }
}
