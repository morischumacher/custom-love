import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_gender_preference.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_pictures.dart';

void main() {
  testWidgets('RegistrationGenderPreference Widget Test',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RegistrationGenderPreference(
          firstName: 'John',
          lastName: 'Doe',
          email: 'john.doe@example.com',
          password: 'password123',
          gender: 'Male',
          preference: 'Female',
          birthdate: '01/01/1990',
          profilePicture: Uint8List(0), // Replace with actual image data
          userInterestIdList: {1, 2, 3},
        ),
      ),
    );

    expect(find.text('Profile Details'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle(); // Wait for any animations to complete

    expect(find.byType(RegistrationPictures), findsOneWidget);
  });
}
