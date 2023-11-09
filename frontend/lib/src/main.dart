import 'package:flutter/material.dart';
import 'package:frontend/src/features/authentication/presentation/login.dart';
import 'package:frontend/src/features/home/presentation/home.dart';

void main() {
  runApp(const CustomLove());
}

class CustomLove extends StatelessWidget {
  const CustomLove({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(), // Default screen with a button
        '/home': (context) => const HomeScreen(), // Home screen
      },
    );
  }
}
