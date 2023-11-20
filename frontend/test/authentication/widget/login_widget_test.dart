import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/features/authentication/application/login_service.dart';
import 'package:frontend/src/features/authentication/presentation/login_page.dart';
import 'package:mockito/mockito.dart';

class MockLoginService extends Mock implements LoginService {}

void main() {
  testWidgets('Login widget should contain email and password text fields',
      (WidgetTester tester) async {
    // Create a mock instance of LoginService
    final MockLoginService mockLoginService = MockLoginService();

    // Stub any necessary methods if needed
    // when(mockLoginService.someMethod()).thenAnswer((_) => Future.value(someValue));

    await tester.pumpWidget(MaterialApp(
      home: LoginPage(loginService: mockLoginService),
    ));

    // Expect to find the email text field
    expect(find.byKey(const Key('emailTextField')), findsOneWidget);

    // Expect to find the password text field
    expect(find.byKey(const Key('passwordTextField')), findsOneWidget);
  });
}
