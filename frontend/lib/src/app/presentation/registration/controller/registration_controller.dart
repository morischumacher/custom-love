import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/src/app/service/registration_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../../config/app_state.dart';
import '../../../model/user_model.dart';
import '../../../service/user_service.dart';

class RegistrationController {
  var logger = Logger();
  Position? userLocation;

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
    UserService userService = context.read<UserService>();

    try {
      // Wait for the completion of the registration service
      Map<String, dynamic> registrationResult =
      await registrationService.registerTo(
          firstName!,
          lastName!,
          email!,
          password!,
          bio!,
          birthdate!,
          job!,
          1,
          1
      );

      var accessToken = registrationResult["access_token"];
      await storeAccessToken(accessToken);

      var userId = registrationResult["user"]["id"];
      await storeUserId(userId.toString());

      // If registration is successful, navigate to '/home/swipe'
      if (context.mounted) {
        print("UserLocation");
        userLocation = Position(
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
        );
        print(userLocation);
        userService.updateCurrentUserLocation(userLocation!, accessToken);

        // load users, conversations, matches and first messages
        unawaited(Provider.of<StateManager>(context, listen: false).initialize(context));

        // save the user object and connect to a websocket
        print("REGISTRATION RESULT");
        print(registrationResult['user']);
        Provider.of<StateManager>(context, listen: false).registerUser(User.fromJson(registrationResult['user']), context);

        Navigator.of(context).pushNamed('/home/swipe');
      }
    } catch (e) {
      print('Entered exception: $e');
      // TODO: Handle different exceptions
    }

  }

  // TODO: Duplicated code (included in login_controller)
  Future<void> storeAccessToken(String accessToken) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.write(key: "access_token", value: accessToken);
  }

  Future<String?> retrieveAccessToken() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    return await storage.read(key: "access_token");
  }

  Future<void> storeUserId(String id) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.write(key: "user_id", value: id);
  }
}
