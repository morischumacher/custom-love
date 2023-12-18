import 'package:frontend/src/app/api/registration_api.dart';

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
      int searchRadius,
      int genderIdentityId
    ) async {
    try {
      print("REGISTRATION API");
      final body = _registrationApi.registerUser(
          firstName,
          lastName,
          email,
          password,
          bio,
          birthdate,
          job,
          searchRadius,
          10,
          genderIdentityId,
          "2024-11-18T11:11:27.137918"
      );
      return body;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
