import 'package:flutter/rendering.dart';
import 'package:frontend/src/app/presentation/authentification/pages/login_page.dart';
import 'package:frontend/src/app/presentation/authentification/pages/logout_page.dart';
import 'package:frontend/src/app/presentation/chat/pages/matches_page.dart';
import 'package:frontend/src/app/presentation/chat/pages/messages_page.dart';
import 'package:frontend/src/app/presentation/loading_screen/loading_screen.dart';
import 'package:frontend/src/app/service/login_service.dart';
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
import '../../../../config/app_state.dart';
import '../../../api/helpers/jwt_api.dart';
import '../../authentification/controller/login_controller.dart';

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
  int swipingAlgoId = 0;
  AlgoIdNotifier? algoIdNotifier;
  bool? _userLoggedIn;

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  @override
  void initState() {
    super.initState();
    getAccessToken().then((token){
      if (token != null) {
        setState(() {
          _userLoggedIn = true;
        });
      }
    });
  }

  Future<String?> getAccessToken() async {
    try {
      return await JWTApi.retrieveAccessToken();
    } catch (e) {
      Navigator.pushNamed(context, '/');
      return null;
    }
  }

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
    if (algoIdNotifier?.algoId != algoId) {
      algoIdNotifier?.setAlgoId(algoId);
    }
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    algoIdNotifier ??= Provider.of<AlgoIdNotifier>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    String url = getUrl(context);
    Widget Function(BuildContext context) route = routePage(url);

    return _userLoggedIn == null ? const LoadingScreen() : Scaffold(
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
          // surfaceTintColor has to be set to the desired background color
          surfaceTintColor: _customLoveTheme.neutralBackgroundColor,
          icon: const Icon(Icons.tune, size: 28, color: Colors.black,),
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            popUpMenuItem("Random Algorithm", 1),
            popUpMenuItem("Interest-based Algorithm", 2),
            popUpMenuItem("Preference-based Algorithm", 3),
          ]
      ),
    );
  }

  PopupMenuEntry popUpMenuItem(value, algoId) {
    return PopupMenuItem(
      height: 0,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      value: value,
      child: Container(
      decoration: BoxDecoration(
        color: algoIdNotifier?.algoId == algoId ? _customLoveTheme.neutralColor : null,
        borderRadius: const BorderRadius.all(Radius.circular(5))
      ),
      child: ListTile(
        title: Text(value, style: const TextStyle(fontSize: 13)),
        onTap: () {
          _changeAlgoId(context, algoId);
          Navigator.pop(context);
        },
      ))
    );
  }

}
