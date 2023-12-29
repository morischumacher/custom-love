import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_interests.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/interest.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';

void main() {
  testWidgets('RegistrationInterests displays UI elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RegistrationInterests(
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
    expect(find.byType(Interest), findsNWidgets(20));
    expect(find.byType(OutlinedButton), findsNWidgets(2));
  });
}
