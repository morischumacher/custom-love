import 'package:flutter/rendering.dart';
import 'package:frontend/src/app/presentation/authentification/pages/logout_page.dart';
import 'package:frontend/src/app/presentation/chat/pages/matches_page.dart';
import 'package:frontend/src/app/presentation/chat/pages/messages_page.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/src/app/service/swipe_status_service.dart';
import 'package:frontend/src/app/presentation/swipe/util/algo_id_notifier.dart';
import "package:universal_html/html.dart" as universal_html;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/chat/pages/conversations_page.dart';
import 'package:frontend/src/config/theme.dart';
import 'package:frontend/src/app/presentation/profile/pages/profile.dart';
import 'package:frontend/src/app/presentation/swipe/pages/swipe.dart';
import 'package:frontend/src/app/service/user_service.dart';

import 'package:provider/provider.dart';

import '../../swipe/util/matching_algorithm.dart';

enum AppPage { profile, swipe, matches }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required UserService userService, SwipeStatusService? swipeStatusService})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late bool isOnSwipePage;
  late AppPage _currentPage;

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  void setCurrentPage(AppPage page) {
    setState(() {
      _currentPage = page;
    });
  }

  Widget Function(BuildContext) routePage(String url) {
    switch(url) {
      case 'profile':
        setCurrentPage(AppPage.profile);
        return (BuildContext context) => Profile(userService: context.read<UserService>());
      case 'swipe':
        setCurrentPage(AppPage.swipe);
        return (BuildContext context) => Swipe(userService: context.read<UserService>(), swipeStatusService: context.read<SwipeStatusService>());
      case 'matches' || 'messages':
        setCurrentPage(AppPage.matches);
        return (BuildContext context) => const MatchesPage();
      default:
        setCurrentPage(AppPage.swipe);
        return (BuildContext context) => Swipe(userService: context.read<UserService>(), swipeStatusService: context.read<SwipeStatusService>());
    }
  }

  Future<void> changeRoute(int index, BuildContext context) async {
    String str = AppPage.values[index].toString();
    String subRouteName = str.split(".")[1].toLowerCase();
    String subRoute = '/home/$subRouteName';

    if (!context.mounted) return;
    if (subRouteName == "swipe") {
      var prevRoute = ModalRoute.of(context);
      if (prevRoute != null) {
        Navigator.of(context).removeRouteBelow(prevRoute);
      }
    }
    Navigator.pushNamed(context, subRoute);
  }

  String getUrl(BuildContext context) {
    // navigator is corrupt - logout
    if (ModalRoute.of(context) == null) {
      Navigator.of(context).pushNamed(
        "/logout",
        arguments: const LogoutRouteArguments("Internal App Error: Navigator corrupt"),
      );
    }

    var url = ModalRoute.of(context)!.settings.name!;
    List<String> urlSubsections = url.split("/");
    String subRoute = urlSubsections[urlSubsections.length - 1].toLowerCase();

    return subRoute;
  }

  Future<void> _changeAlgoId(BuildContext context, int algoId) async {
    final algoIdNotifier = Provider.of<AlgoIdNotifier>(context, listen: false);
    if (algoIdNotifier.algoId != algoId) {
      algoIdNotifier.setAlgoId(algoId);
    }
  }

  @override
  Widget build(BuildContext context) {
    String url = getUrl(context);
    Widget Function(BuildContext context) route = routePage(url);

    return Scaffold(
      appBar: AppBar(
        title: getTitle(),
        backgroundColor: _customLoveTheme.primaryColor,
        actions: [ _currentPage.index == 1 ?
          algoSwitcherMenu() : Container(),
        ],
      ),
      body: route(context),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage.index,
        onTap: (int index) => changeRoute(index, context),
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

  Widget getTitle() {
    if (ModalRoute.of(context)!.settings.arguments is MessagesPageRouteArguments) {
      final args = ModalRoute.of(context)!.settings.arguments as MessagesPageRouteArguments;
      return Text("${args.user.firstName} ${args.user.lastName}");
    }

    return const Text("Custom Love App");
  }

  Widget algoSwitcherMenu(){
   return Padding(
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
                  _changeAlgoId(context, 1);
                  Navigator.pop(context);
                },
              ),
            ),
            PopupMenuItem(
              value: "Interest-based Algorithm",
              child: ListTile(
                title: const Text("Interest-based Algorithm", style: TextStyle(fontSize: 13)),
                onTap: () {
                  _changeAlgoId(context, 2);
                  Navigator.pop(context);
                },
              ),
            ),
            PopupMenuItem(
              value: "Preference-based Algorithm",
              child: ListTile(
                title: const Text("Preference-based Algorithm", style: TextStyle(fontSize: 13)),
                onTap: () {
                  _changeAlgoId(context, 3);
                  Navigator.pop(context);
                },
              ),
            )
          ]
      ),
    );
  }
}
