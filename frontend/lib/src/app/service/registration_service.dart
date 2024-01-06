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
          genderIdentityId
      );
      return body;
    } catch (e) {
      rethrow;
    }
  }
}
