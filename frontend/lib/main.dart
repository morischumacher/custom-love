import 'package:flutter/material.dart';

void main() {
  runApp(const MyWidget());
}

// stateless widget for hot reload
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text("CustomLove"),
            ),
            backgroundColor: Colors.pink[800],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Colors.pink[100],
                width: 150.0,
                height: 150.0,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20.0),
                child: Text("Profile"),
              ),
            ],
          )),
    );
  }
}
