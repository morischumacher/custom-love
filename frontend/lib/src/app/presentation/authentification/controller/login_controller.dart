import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/src/app/service/login_service.dart';
import 'package:frontend/src/app/service/user_service.dart';
import 'package:frontend/src/config/app_state.dart';
import 'package:frontend/src/config/exceptions.dart';
import 'package:frontend/src/config/theme.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../../model/user_model.dart';
import '../../swipe/util/algo_id_notifier.dart';

class LoginController {
  var logger = Logger();
  Position? userLocation;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

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

  Future<String?> retrieveUserId() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    return await storage.read(key: "user_id");
  }

  Future<void> handleLogin(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;
    LoginService loginService = context.read<LoginService>();
    UserService userService = context.read<UserService>();

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        // Wait for the completion of the login service
        Map<String, dynamic> loginResult =
            await loginService.loginTo(email, password);

        var accessToken = loginResult["access_token"];

        await storeAccessToken(accessToken);

        var userId = loginResult["user"]["id"];

        await storeUserId(userId.toString());

        var userMatchingAlgorithm = loginResult["user"]["matching_algorithm"];
        if(userMatchingAlgorithm != null || userMatchingAlgorithm != 0) {
          algoIdNotifier.setAlgoId(userMatchingAlgorithm);
        } else {
          //TODO Launch onboarding process
        }

        // If login is successful, navigate to '/home'
        if (context.mounted) {
          userService.updateCurrentUserLocation(userLocation!, accessToken);

          // load users, conversations, matches and first messages
          unawaited(Provider.of<StateManager>(context, listen: false)
              .initialize(context, force: true));

          // save the user object and connect to a websocket
          Provider.of<StateManager>(context, listen: false)
              .registerUser(User.fromJson(loginResult['user']), context);

          Navigator.of(context).pushNamed('/home/swipe');
        }
      } catch (e) {
        // Handle different exceptions
        if (e is WrongEmailException) {
          if (context.mounted) {
            errorMessage(context, e.message);
          }
        } else if (e is WrongPasswordException) {
          if (context.mounted) {
            errorMessage(context, e.message);
          }
        } else {
          if (context.mounted) {
            errorMessage(context, "Error during Authentication");
          }
        }
      }
    }
  }

  // error during login message popup
  void errorMessage(context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: _customLoveTheme.primaryColor,
          title: Center(
            child: Text(
              message,
              style: TextStyle(color: _customLoveTheme.neutralColor),
            ),
          ),
        );
      },
    );
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
