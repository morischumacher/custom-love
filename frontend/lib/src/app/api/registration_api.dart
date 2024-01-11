import 'dart:convert';
import 'dart:typed_data';
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
      Position location,
      int searchRadius,
      int genderIdentityId,
      List<int> genderPreferenceIds,
      Uint8List? profilePicture,
      List<int> interests,
      List<int> languages
      ) async {
    // TODO: Change body according to userDto
    // Missing:
    //   * profilePicture (separate issue)
    final response = await httpClient.post(
        Uri.parse('${ApiConfig.baseUrl}/users/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(<String, dynamic>{
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "password": password,
          "bio": bio,
          "date_of_birth": birthdate,
          "job": job,
          "search_radius": searchRadius.toString(),
          "gender_identity_id": genderIdentityId.toString(),
          "gender_preference_ids": genderPreferenceIds,
          "longitude": location.longitude.toString(),
          "latitude": location.latitude.toString(),
          "interest_ids": interests,
          "matching_algorithm": 1.toString(),
          "language_ids": languages
        })
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 422) {
      throw InvalidRegistrationInputsException();
    } else {
      throw Exception('Error during Registration');
    }
  }
}
