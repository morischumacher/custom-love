import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/src/features/authentication/presentation/login_controller.dart';

void main() {
  test('This test is a sample test and is just for learning purposes', () {
    final LoginController loginController = LoginController();
    expect(true, loginController.isTestable(0, 0));
  });

  test('isTestable should return false', () {
    final LoginController loginController = LoginController();
    expect(false, loginController.isTestable(1, 1));
  });
}
