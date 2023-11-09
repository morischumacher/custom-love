import 'package:flutter/material.dart';
import 'package:frontend/src/features/authentication/presentation/login.dart';

void main() {
  runApp(const CustomLove());
}

class CustomLove extends StatefulWidget {
  const CustomLove({Key? key}) : super(key: key);

  @override
  _CustomLoveState createState() => _CustomLoveState();
}

class _CustomLoveState extends State<CustomLove> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const Login(),
    // Add other pages here
    Container(
      color: Colors.blue,
      child: const Center(child: Text('Page 2')),
    ),
    Container(
      color: Colors.green,
      child: const Center(child: Text('Page 3')),
    ),
    Container(
      color: Colors.orange,
      child: const Center(child: Text('Page 4')),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Custom Love App'),
        ),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          unselectedItemColor:
              Colors.grey, // Set the color for unselected items
          selectedItemColor:
              Colors.pink[800], // Set the color for the selected item
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.login),
              label: 'Login',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pages),
              label: 'Page 3',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pages),
              label: 'Page 4',
            ),
          ],
        ),
      ),
    );
  }
}
