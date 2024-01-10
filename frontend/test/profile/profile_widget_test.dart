import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/app/presentation/profile/pages/profile.dart';
import 'package:frontend/src/app/service/user_service.dart';
import 'package:mockito/mockito.dart';

class MockUserService extends Mock implements UserService {}

void main() {
  testWidgets('ProfilePage UI Test', (WidgetTester tester) async {
    final MockUserService mockUserService = MockUserService();

    await tester.pumpWidget(
      MaterialApp(
        home: Profile(userService: mockUserService),
      ),
    );

    // TODO: Change if profile is changing
    expect(find.text('Placeholder'), findsOneWidget);
  });
}
