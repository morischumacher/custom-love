import 'package:flutter/material.dart';
import 'package:frontend/src/app/service/user_service.dart';

class TrainingsDataPage extends StatelessWidget {
  const TrainingsDataPage({Key? key, required UserService userService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: DummySwipeCardList(),
        ),
      ),
    );
  }
}

class DummySwipeCardList extends StatelessWidget {
  final List<DummyUser> dummyUsers =
      List.generate(10, (index) => DummyUser(index));

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dummyUsers.length,
      itemBuilder: (context, index) {
        return DummySwipeCard(user: dummyUsers[index]);
      },
    );
  }
}

class DummySwipeCard extends StatelessWidget {
  final DummyUser user;

  DummySwipeCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                    'assets/user_placeholder_image.jpg'), // Replace with your image
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User ${user.id}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Age: ${user.age}',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 16),
                Text(
                  'Bio: ${user.bio}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Handle like action
                  print('Liked User ${user.id}');
                },
                style: ElevatedButton.styleFrom(primary: Colors.green),
                child: Icon(Icons.favorite),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle dislike action
                  print('Disliked User ${user.id}');
                },
                style: ElevatedButton.styleFrom(primary: Colors.red),
                child: Icon(Icons.close),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DummyUser {
  final int id;
  final int age;
  final String bio;

  DummyUser(this.id)
      : age = 18 + id % 10,
        bio = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
}
