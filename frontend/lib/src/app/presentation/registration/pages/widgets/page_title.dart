import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({
    Key? key,
    required this.title,
    required this.description,
    required this.bottomPadding
  })
      : super(key: key);

  final String title;
  final String description;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 51.0),
      SizedBox(
          child: Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'roboto',
                  fontSize: 34.0,
                  color: Colors.black,
                  decoration: TextDecoration.none))),
      SizedBox(
          child: Text(description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w100,
                fontFamily: 'roboto',
                color: Color(0xFF797C7B), // Colors.white70
                decoration: TextDecoration.none,
                fontStyle: FontStyle.italic,
              ))),
      SizedBox(height: bottomPadding)
    ]);
  }
}
