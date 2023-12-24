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
      int genderPreferenceId,
      Uint8List? profilePicture,
      List<int> interests
      ) async {
    // Following attributes are not forwarded by the frontend, but handled by
    // the backend: swipesLeft, swipeLimitResetDate

    // TODO: Change body according to userDto
    // Missing:
    //   * genderPreferenceId
    //   * interests
    //   * profilePicture (separate issue)
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
          "gender_identity_id": genderIdentityId.toString(),
          "gender_preference_id": genderPreferenceId.toString(),
          "swipes_left": 10.toString(),
          "swipe_limit_reset_date": DateTime.now().toString(),
          "longitude": location.longitude.toString(),
          "latitude": location.latitude.toString(),
          "interest_ids": interests.toString()
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
