import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_name_email.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/textfield.dart';

void main() {
  testWidgets('RegistrationNameEmail UI Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: RegistrationNameEmail(
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
    expect(find.byType(RegistrationTextfield), findsNWidgets(4));
    expect(find.byType(OutlinedButton), findsNWidgets(2));
  });
}
