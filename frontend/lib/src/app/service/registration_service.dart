import 'dart:typed_data';

import 'package:frontend/src/app/api/registration_api.dart';
import 'package:geolocator/geolocator.dart';

class RegistrationService {
  final RegistrationApi _registrationApi;

  RegistrationService(this._registrationApi);

  Future<Map<String, dynamic>> registerTo(
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
      List<int> userInterestIdSet
    ) async {
    try {
      final body = _registrationApi.registerUser(
          firstName,
          lastName,
          email,
          password,
          bio,
          birthdate,
          job,
          location,
          searchRadius,
          genderIdentityId,
          genderPreferenceIds,
          null,
          userInterestIdSet
      );
      return body;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
