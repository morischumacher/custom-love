import 'package:flutter/material.dart';
import 'package:frontend/src/config/exceptions.dart';
import 'package:frontend/src/config/theme.dart';
import 'package:logger/logger.dart';
import 'package:frontend/src/features/authentication/application/login_service.dart';
import 'package:provider/provider.dart';

class LoginController {
  var logger = Logger();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  Future<void> handleLogin(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;
    LoginService loginService = context.read<LoginService>();

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        // Wait for the completion of the login service
        Map<String, dynamic> loginResult =
            await loginService.loginTo(email, password);

        // If login is successful, navigate to '/home'
        if (context.mounted) {
          Navigator.of(context).pushNamed('/home');
        }
      } catch (e) {
        // Handle different exceptions
        if (e is UnauthorizedException) {
          if (context.mounted) {
            errorMessage(context, e.message);
          }
        } else {
          if (context.mounted) {
            errorMessage(context, "Error during Authentification");
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

  // This is a sample method to introduce unit testing in frontend
  bool isTestable(int a, int b) {
    if (a == 0 || b == 0) {
      return true;
    }
    return false;
  }
}
