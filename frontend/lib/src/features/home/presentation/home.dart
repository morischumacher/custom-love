import 'package:flutter/material.dart';
import 'package:frontend/src/features/authentication/application/user_service.dart';
import 'package:frontend/src/features/matches/presentation/matches.dart';
import 'package:frontend/src/features/profile/presentation/profile.dart';
import 'package:frontend/src/features/swipe/presentation/swipe.dart';
import 'package:provider/provider.dart';

enum AppPage { Profile, Swipe, Matches }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required UserService userService})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppPage _currentPage = AppPage.Swipe; // Default page

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Love App'),
        backgroundColor: Colors.pink[800],
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
        selectedItemColor: Colors.pink[800],
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
        return const Swipe();
      case AppPage.Matches:
        return const Matches();
    }
  }
}
