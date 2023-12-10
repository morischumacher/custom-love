import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/user_model.dart';
import 'package:frontend/src/app/service/user_service.dart';

class Profile extends StatefulWidget {
  final UserService userService;

  const Profile({Key? key, required this.userService}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Placeholder")
      ),
    );
  }
}
