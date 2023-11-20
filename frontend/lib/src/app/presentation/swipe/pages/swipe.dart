import 'package:flutter/material.dart';

class Swipe extends StatefulWidget {
  const Swipe({Key? key}) : super(key: key);

  @override
  _SwipeState createState() => _SwipeState();
}

class _SwipeState extends State<Swipe> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.green, // Set your desired background color here,
        child: const Center(child: Text('Swipe')));
  }
}
