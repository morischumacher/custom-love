import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/src/app/model/gender_model.dart';
import 'package:frontend/src/app/model/interest_model.dart';
import 'package:frontend/src/app/service/registration_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../../config/app_state.dart';
import '../../../model/user_model.dart';
import '../../../service/user_service.dart';

class RegistrationController {
  var logger = Logger();
  Future<void> handleRegistration(
      BuildContext context,
      final String? firstName,
      final String? lastName,
      final String? email,
      final String? password,
      final String? bio,
      final String? birthdate,
      final String? job,
      final Position? location,
      final double? searchRadius,
      final Gender? gender,
      final Gender? genderPreference,
      final Uint8List? profilePicture,
      final List<Interest> userInterestIdList
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
          bio ?? "",
          convertDateToJsonDate(birthdate!),
          job ?? "",
          location!,
          searchRadius!.toInt(),
          gender!.id,
          genderPreference!.id,
          null,
          convertInterestListToInterestIdList(userInterestIdList)
      );

      var accessToken = registrationResult["access_token"];
      await storeAccessToken(accessToken);

      var userId = registrationResult["user"]["id"];
      await storeUserId(userId.toString());

      // If registration is successful, navigate to '/home/swipe'
      if (context.mounted) {
        userService.updateCurrentUserLocation(location, accessToken);

        // load users, conversations, matches and first messages
        unawaited(Provider.of<StateManager>(context, listen: false).initialize(context));

        // save the user object and connect to a websocket
        Provider.of<StateManager>(context, listen: false).registerUser(User.fromJson(registrationResult['user']), context);

        Navigator.of(context).pushNamed('/home/swipe');
      }
    } catch (e) {
      logger.e('Entered exception: $e');
      // TODO: Handle different exceptions
    }

  }

  String convertDateToJsonDate(String date) {
    return "${date}T00:00:00.0";
  }

  List<int> convertInterestListToInterestIdList(List<Interest> interests) {
    List<int> interestIds = [];
    for (Interest interest in interests) {
      interestIds.add(interest.id);
    }
    return interestIds;
  }

  // TODO: Duplicated code (included in login_controller)
  Future<void> storeAccessToken(String accessToken) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.write(key: "access_token", value: accessToken);
  }

  // TODO: Duplicated code (included in login_controller)
  Future<String?> retrieveAccessToken() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    return await storage.read(key: "access_token");
  }

  // TODO: Duplicated code (included in login_controller)
  Future<void> storeUserId(String id) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.write(key: "user_id", value: id);
  }
}
