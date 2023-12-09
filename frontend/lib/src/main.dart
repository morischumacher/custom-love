import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/utils/CustomScrollBehaviour.dart';
import 'package:frontend/src/app/service/conversation_service.dart';
import 'package:frontend/src/app/service/match_service.dart';
import 'package:frontend/src/app/service/message_service.dart';
import 'package:frontend/src/app/api/registration_api.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_name_email.dart';
import 'package:frontend/src/app/service/registration_service.dart';
import 'package:frontend/src/config/theme.dart';
import 'package:frontend/src/app/presentation/authentification/pages/login_page.dart';
import 'package:frontend/src/app/presentation/home/pages/home.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'app/api/conversation_api.dart';
import 'app/api/login_api.dart';
import 'app/api/match_api.dart';
import 'app/api/message_api.dart';
import 'app/api/user_api.dart';
import 'app/service/login_service.dart';
import 'app/service/user_service.dart';
import 'config/app_state.dart';

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
        //ChangeNotifierProvider<CustomLoveState>(create: (context) => CustomLoveState()),
        ChangeNotifierProvider<StateManager>(create: (_) => StateManager()),
        ChangeNotifierProvider<UserStorage>(create: (_) => UserStorage()),
        ChangeNotifierProvider<ConversationStorage>(create: (_) => ConversationStorage()),
        ChangeNotifierProvider<MessageStorage>(create: (_) => MessageStorage()),
        ChangeNotifierProvider<MatchStorage>(create: (_) => MatchStorage()),
        Provider<http.Client>.value(value: httpClient),
        ProxyProvider<http.Client, UserApi>(
          update: (_, httpClient, __) => UserApi(httpClient),
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
        ProxyProvider<http.Client, RegistrationApi>(
          update: (_, httpClient, __) => RegistrationApi(httpClient: httpClient),
        ),
        ProxyProvider<RegistrationApi, RegistrationService>(
          update: (_, registrationApi, __) => RegistrationService(registrationApi),
        ),
        ProxyProvider<http.Client, ConversationApi>(
          update: (_, httpClient, __) => ConversationApi(httpClient),
        ),
        ProxyProvider<ConversationApi, ConversationService>(
          update: (_, conversationApi, __) => ConversationService(conversationApi),
        ),
        ProxyProvider<http.Client, MatchApi>(
          update: (_, httpClient, __) => MatchApi(httpClient),
        ),
        ProxyProvider<MatchApi, MatchService>(
          update: (_, matchApi, __) => MatchService(matchApi),
        ),
        ProxyProvider<http.Client, MessageApi>(
          update: (_, httpClient, __) => MessageApi(httpClient),
        ),
        ProxyProvider<MessageApi, MessageService>(
          update: (_, messageApi, __) => MessageService(messageApi),
        )
      ],
      child: MaterialApp(
        scrollBehavior: CustomScrollBehaviour(),
        theme: _customLoveTheme.toThemeData(),
        initialRoute: '/',
        routes: {
          '/': (context) {
            final loginService = Provider.of<LoginService>(context);
            final userService = Provider.of<UserService>(context);
            final conversationService = Provider.of<ConversationService>(context);
            final matchService = Provider.of<MatchService>(context);
            final messageService = Provider.of<MessageService>(context);
            return LoginPage(
                loginService: loginService, userService: userService);
          },
          '/home/profile': (context) {
            final userService = Provider.of<UserService>(context);
            return HomeScreen(userService: userService);
          },
          '/home/swipe': (context) {
            final userService = Provider.of<UserService>(context);
            return HomeScreen(userService: userService);
          },
          '/home/matches': (context) {
            final userService = Provider.of<UserService>(context);
            final conversationService = Provider.of<ConversationService>(context);
            final matchService = Provider.of<MatchService>(context);
            final messageService = Provider.of<MessageService>(context);
            return HomeScreen(userService: userService);
          },
          '/registration': (context) {
            // return const RegistrationGenderPreference();
            return RegistrationNameEmail(
              name: null,
              email: null,
              gender: null,
              preference: null,
              birthdate: null,
              profilePicture: null,
              userInterestIdList: Set<int>()
            );
          }
        },
      ),
    );
  }
}
