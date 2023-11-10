import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/features/authentication/presentation/login.dart'; // Replace with the actual path to your login.dart file

void main() {
  testWidgets('Login widget should contain email and password text fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Login(),
    ));

    expect(find.byKey(const Key('emailTextField')), findsOneWidget);

    expect(find.byKey(const Key('passwordTextField')), findsOneWidget);
  });
}
