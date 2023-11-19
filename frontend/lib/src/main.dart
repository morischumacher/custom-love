import 'package:flutter/material.dart';
import 'package:frontend/src/config/theme.dart';
import 'package:frontend/src/features/authentication/api/login_repository.dart';
import 'package:frontend/src/features/authentication/application/login_service.dart';
import 'package:frontend/src/features/authentication/application/user_service.dart';
import 'package:frontend/src/features/authentication/presentation/login_page.dart';
import 'package:frontend/src/features/home/presentation/home.dart';
import 'package:frontend/src/features/authentication/api/user_repository.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';

void main() {
  runApp(const CustomLove());
}

class CustomLove extends StatelessWidget {
  const CustomLove({Key? key}) : super(key: key);
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

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
        ProxyProvider<http.Client, LoginRepository>(
          update: (_, httpClient, __) =>
              LoginRepository(httpClient: httpClient),
        ),
        ProxyProvider<LoginRepository, LoginService>(
          update: (_, loginRepository, __) => LoginService(loginRepository),
        ),
      ],
      child: MaterialApp(
        theme: _customLoveTheme.toThemeData(),
        initialRoute: '/',
        routes: {
          '/': (context) {
            final loginService = Provider.of<LoginService>(context);
            return LoginPage(loginService: loginService);
          },
          '/home': (context) {
            final userService = Provider.of<UserService>(context);
            return HomeScreen(userService: userService);
          },
        },
      ),
    );
  }
}
