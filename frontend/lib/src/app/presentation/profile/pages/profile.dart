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
    return Scaffold(
        /*body: Center(
        child: FutureBuilder<List<User>>(
          future: widget.userService.getAllUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final users = snapshot.data!;
              return users.isNotEmpty
                  ? Center(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final user = users[index];
                          return ListTile(
                            title: Text('${user.firstName} ${user.lastName}'),
                            subtitle: Text(user.job),
                          );
                        },
                      ),
                    )
                  : const Text('No Users');
            } else {
              return const Text('No data available.');
            }
          },
        ),
      ),*/
        );
  }
}
