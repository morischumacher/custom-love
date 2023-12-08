import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_gender_preference.dart';
import 'package:frontend/src/app/service/registration_service.dart';
import 'package:frontend/src/app/service/user_service.dart';
import 'package:frontend/src/config/exceptions.dart';
import 'package:frontend/src/config/theme.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../home/pages/home.dart';

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
      final String? preference,
      final String? birthdate,
      final String? job,
      final Uint8List? profilePicture,
      final Set<int> userInterestIdList,
      final int genderIdentityId
    ) async {
    print("HERE\nREACHED");

    RegistrationService registrationService = context.read<RegistrationService>();

    /*
    if (firstName != null && lastName != null && email != null
        && password != null && bio != null && birthdate != null && job != null) {
     */
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

        print(registrationResult);
        /*
        var accessToken = loginResult["access_token"];

        await storeAccessToken(accessToken);
         */

        // If login is successful, navigate to '/home'
        if (context.mounted) {
          // Navigator.of(context).pushNamed('/home');

          /*
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return HomeScreen(userService: Provider.of<UserService>(context));
          }));
           */
          print("SUCCESS");

        }
      } catch (e) {
        print("Entered exception");
        print(e);
        // TODO: Handle different exceptions
      }

  }
}
