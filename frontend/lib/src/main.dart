import 'package:flutter/material.dart';
import 'package:frontend/src/features/authentication/application/user_service.dart';
import 'package:frontend/src/features/authentication/presentation/login.dart';
import 'package:frontend/src/features/home/presentation/home.dart';
import 'package:frontend/src/features/authentication/data/user_repository.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';

void main() {
  runApp(const CustomLove());
}

class CustomLove extends StatelessWidget {
  const CustomLove({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final http.Client httpClient = http.Client();
    return MultiProvider(
      providers: [
        Provider<http.Client>.value(value: httpClient),
        ProxyProvider<http.Client, UserRepository>(
          update: (_, httpClient, __) => UserRepository(httpClient: httpClient),
        ),
        ProxyProvider<UserRepository, UserService>(
          update: (_, userRepository, __) => UserService(userRepository),
        ),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const Login(),
          '/home': (context) {
            final userService = Provider.of<UserService>(context);
            return HomeScreen(userService: userService);
          },
        },
      ),
    );
  }
}
