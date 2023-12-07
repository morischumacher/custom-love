import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_name_email.dart';
import 'package:frontend/src/config/theme.dart';
import 'package:frontend/src/app/presentation/authentification/pages/login_page.dart';
import 'package:frontend/src/app/presentation/home/pages/home.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'app/api/login_api.dart';
import 'app/api/user_api.dart';
import 'app/service/login_service.dart';
import 'app/service/user_service.dart';

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
        ProxyProvider<http.Client, UserApi>(
          update: (_, httpClient, __) => UserApi(httpClient: httpClient),
        ),
        ProxyProvider<UserApi, UserService>(
          update: (_, userApi, __) => UserService(userApi),
        ),
        ProxyProvider<http.Client, LoginApi>(
          update: (_, httpClient, __) => LoginApi(httpClient: httpClient),
        ),
        ProxyProvider<LoginApi, LoginService>(
          update: (_, loginApi, __) => LoginService(loginApi),
        ),
      ],
      child: MaterialApp(
        theme: _customLoveTheme.toThemeData(),
        initialRoute: '/',
        routes: {
          '/': (context) {
            final loginService = Provider.of<LoginService>(context);
            final userService = Provider.of<UserService>(context);
            return LoginPage(
                loginService: loginService, userService: userService);
          },
          '/home': (context) {
            final userService = Provider.of<UserService>(context);
            return HomeScreen(userService: userService);
          },
          '/registration': (context) {
            // return const RegistrationGenderPreference();
            return const RegistrationNameEmail(
              name: null,
              email: null,
              gender: null,
              preference: null,
              birthdate: null,
            );
          }
        },
      ),
    );
  }
}
