import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/src/app/service/registration_service.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class RegistrationController {
  var logger = Logger();

  Future<void> handleRegistration(
      BuildContext context,
      final String? firstName,
      final String? lastName,
      final String? email,
      final String? password,
      final String? bio,
      final String? gender,
      final String? genderPreference,
      final String? birthdate,
      final String? job,
      final Uint8List? profilePicture,
      final Set<int> userInterestIdList,
      final int genderIdentityId
    ) async {

    RegistrationService registrationService = context.read<RegistrationService>();

    try {
      // Wait for the completion of the registration service
      Map<String, dynamic> registrationResult =
      await registrationService.registerTo(
          "firstName",
          "lastName",
          "email",
          "password",
          "bio",
          "birthdate",
          "job",
          1
      );

      // If login is successful, navigate to '/home'
      if (context.mounted) {
        print("SUCCESS");

      }
    } catch (e) {
      print("Entered exception");
      print(e);
      // TODO: Handle different exceptions
    }

  }
}
