import 'package:flutter/rendering.dart';
import 'package:frontend/src/app/presentation/chat/pages/matches_page.dart';
import 'package:frontend/src/app/presentation/chat/pages/messages_page.dart';
import "package:universal_html/html.dart" as universal_html;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/chat/pages/conversations_page.dart';
import 'package:frontend/src/app/presentation/swipe/util/shared_algorithm_event.dart';
import 'package:frontend/src/config/theme.dart';
import 'package:frontend/src/app/presentation/profile/pages/profile.dart';
import 'package:frontend/src/app/presentation/swipe/pages/swipe.dart';
import 'package:frontend/src/app/service/user_service.dart';

import 'package:provider/provider.dart';

import '../../../../config/app_state.dart';
import '../../authentification/controller/login_controller.dart';


enum AppPage { Profile, Swipe, Matches }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required UserService userService})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool isOnSwipePage;

  @override
  void initState() {
    super.initState();
    isOnSwipePage = false;
    var url = universal_html.window.location.href;
    List<String> urlSubsections = url.split("/");
    String subRoute = urlSubsections[urlSubsections.length - 1].toLowerCase();
    switch(subRoute) {
      case 'profile':
        _currentPage = AppPage.Profile;
        break;
      case 'swipe':
        _currentPage = AppPage.Swipe;
        break;
      case 'matches':
        _currentPage = AppPage.Matches;
        break;
      case 'messages':
        _currentPage = AppPage.Matches;
        break;
      default:
        _currentPage = AppPage.Profile;
    }
  }

  late AppPage _currentPage;
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final LoginController _controller = LoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getTitle(),
        backgroundColor: _customLoveTheme.primaryColor,
        actions: [ _currentPage.index == 1 ?
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: PopupMenuButton(
                color: _customLoveTheme.neutralBackgroundColor,
                icon: const Icon(Icons.tune, size: 28, color: Colors.black,),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: "Random Algorithm",
                    child: ListTile(
                      title: const Text("Random Algorithm", style: TextStyle(fontSize: 13)),
                      onTap: () {
                        print("selected");
                        Navigator.pop(context);
                        SharedAlgorithmEvent.algoId.changeAlgoId(1);
                        print("broadcast happened");
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: "Interest-based Algorithm",
                    child: ListTile(
                      title: const Text("Interest-based Algorithm", style: TextStyle(fontSize: 13)),
                      onTap: () {
                        print("selected");
                        Navigator.pop(context);
                        SharedAlgorithmEvent.algoId.changeAlgoId(2);
                        print("broadcast happened");
                      },
                    ),
                  ),
                  PopupMenuItem(
                    value: "Preference-based Algorithm",
                    child: ListTile(
                      title: const Text("Preference-based Algorithm", style: TextStyle(fontSize: 13)),
                      onTap: () {
                        print("selected");
                        Navigator.pop(context);
                        SharedAlgorithmEvent.algoId.changeAlgoId(3);
                        print("broadcast happened");
                      },
                    ),
                  )
                ]
            ),
          ) : Container(),
        ],
      ),
      body: getPage(_currentPage),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage.index,

        onTap: (int index) {
          if (kIsWeb) {
            // Web
            String str = AppPage.values[index].toString();
            String subRouteName = str.split(".")[1].toLowerCase();
            String subRoute = '/home/$subRouteName';
            Navigator.pushNamed(context, subRoute);
          } else {
            // Mobile
            setState(() {
              _currentPage = AppPage.values[index];
            });
          }
        },
        unselectedItemColor: Colors.grey,
        selectedItemColor: _customLoveTheme.primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_none),
            label: 'Swipe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_rounded),
            label: 'Matches',
          ),
        ],
      ),
    );
  }

  Widget getPage(AppPage page) {
    switch (page) {
      case AppPage.Profile:
        return Profile(userService: context.read<UserService>());
      case AppPage.Swipe:
        return Swipe(userService: context.read<UserService>());
      case AppPage.Matches:
        return const MatchesPage();
    }
  }

  Widget getTitle() {
    if (ModalRoute.of(context)!.settings.arguments is MessagesPageRouteArguments) {
      final args = ModalRoute.of(context)!.settings.arguments as MessagesPageRouteArguments;
      return Text("${args.user.firstName} ${args.user.lastName}");
    }

    return const Text("Custom Love App");
  }
}
