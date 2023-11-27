import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({Key? key, required this.title, required this.description})
      : super(key: key);

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 51.0),
      SizedBox(
          child: Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 34.0,
                  color: Colors.black,
                  decoration: TextDecoration.none))),
      SizedBox(
          child: Text(description,
              style: const TextStyle(
                fontSize: 14.0,
                color: Color(0xFF797C7B), // Colors.white70
                decoration: TextDecoration.none,
                fontStyle: FontStyle.italic,
              ))),
      const SizedBox(height: 150.0),
    ]);
  }
}
