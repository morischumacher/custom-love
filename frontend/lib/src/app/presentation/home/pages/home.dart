import 'package:flutter/material.dart';
import 'package:frontend/src/config/theme.dart';
import 'package:frontend/src/app/presentation/match/pages/matches.dart';
import 'package:frontend/src/app/presentation/profile/pages/profile.dart';
import 'package:frontend/src/app/presentation/swipe/pages/swipe.dart';
import 'package:frontend/src/app/service/user_service.dart';

import 'package:provider/provider.dart';

enum AppPage { Profile, Swipe, Matches }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required UserService userService})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppPage _currentPage = AppPage.Swipe;
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Love App'),
        backgroundColor: _customLoveTheme.primaryColor,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: PopupMenuButton(
                icon: const Icon(Icons.tune, size: 20, color: Colors.black,),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    value: "Random Algorithm",
                    child: ListTile(
                      title: const Text("Random Algorithm", style: TextStyle(fontSize: 13)),
                      onTap: () {
                        print("selected");
                        Navigator.pop(context);
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
                      },
                    ),
                  )
                ]
            ),
          ),
        ],
      ),
      body: getPage(_currentPage),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage.index,
        onTap: (int index) {
          setState(() {
            _currentPage = AppPage.values[index];
          });
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
        return const Matches();
    }
  }
}
