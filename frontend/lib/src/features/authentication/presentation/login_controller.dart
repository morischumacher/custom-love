import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class LoginController {
  var logger = Logger();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void handleLogin(BuildContext context) {
    String email = emailController.text;
    String password = passwordController.text;
    if (email.isNotEmpty && password.isNotEmpty) {
      logger.i('Login was successful');
      Navigator.of(context).pushNamed('/home');
    } else {
      logger.i('Login failed.');
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
