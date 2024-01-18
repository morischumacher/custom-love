import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/src/app/model/gender_model.dart';
import 'package:frontend/src/app/model/interest_model.dart';
import 'package:frontend/src/app/presentation/utils/secure_storage_service.dart';
import 'package:frontend/src/app/service/registration_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../../config/app_state.dart';
import '../../../model/user_model.dart';
import '../../../service/user_service.dart';
import '../../onboarding/pages/onboarding.dart';
import '../../swipe/util/content.dart';

class RegistrationController {
  var logger = Logger();

  final SecureStorageService _secureStorageService = SecureStorageService();

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
      await _secureStorageService.storeAccessToken(accessToken);

      var userId = registrationResult["user"]["id"];
      await _secureStorageService.storeUserId(userId.toString());

      // for onboarding
      String genderPreferenceString = "";

      switch (genderPreference.id) {
        case 1:
          genderPreferenceString = "male";
          break;
        case 2:
          genderPreferenceString = "female";
          break;
        case 3:
          genderPreferenceString = "divers";
          break;
        default:
          genderPreferenceString = "male";
          break;
      }

      String jsonString = await rootBundle.loadString("assets/exsys_trainings_users_$genderPreferenceString.json");
      final userData = await json.decode(jsonString);
      List<dynamic> users = userData["exsys_trainings_users_$genderPreferenceString"];

      List<Content> usersContent = users.map((item) {
        return Content(
            firstName: item["name"],
            age: item["age"],
            bio: item["bio"],
            interests: List<String>.from(item["interests"]));
      }).toList();

      // If registration is successful, navigate to '/home/swipe'
      if (context.mounted) {
        userService.updateCurrentUserLocation(location, accessToken);

        // load users, conversations, matches and first messages
        unawaited(Provider.of<StateManager>(context, listen: false).initialize(context));

        // save the user object and connect to a websocket
        Provider.of<StateManager>(context, listen: false).registerUser(User.fromJson(registrationResult['user']), context);

        Navigator.of(context).popUntil((route) => route.isFirst);
        //Navigator.of(context).pushReplacementNamed('/home/swipe');
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => OnboardingPage(userService: context.read<UserService>(), usersContent: usersContent)),
        );
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

}
