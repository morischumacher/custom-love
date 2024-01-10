import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_pictures.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';

void main() {
  testWidgets('RegistrationPictures UI Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: RegistrationPictures(
          firstName: null,
          lastName: null,
          email: null,
          password: null,
          gender: null,
          preference: null,
          birthdate: null,
          profilePicture: null,
          userInterestIdList: {},
        ),
      ),
    );

    expect(find.byType(PageTitle), findsOneWidget);
    expect(find.byType(OutlinedButton), findsNWidgets(2));
  });
}
