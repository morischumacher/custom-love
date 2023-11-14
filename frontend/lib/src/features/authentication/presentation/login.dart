import 'package:flutter/material.dart';
import 'package:frontend/src/config/theme.dart';
import 'login_controller.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginController _controller = LoginController();
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  double inputWidth = 327;
  double inputHeight = 56;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Love App'),
        backgroundColor: _customLoveTheme.primaryColor,
      ),
      body: Theme(
        data: _customLoveTheme.toThemeData(),
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Welcome to Custom Love App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: _customLoveTheme.inputWidth,
                      height: _customLoveTheme.inputHeight,
                      child: TextField(
                        key: const Key('emailTextField'),
                        controller: _controller.emailController,
                        decoration: _customLoveTheme.textFieldDecoration ??
                            const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter your email address',
                            ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: _customLoveTheme.inputWidth,
                      height: _customLoveTheme.inputHeight,
                      child: TextField(
                        key: const Key('passwordTextField'),
                        controller: _controller.passwordController,
                        obscureText: true,
                        decoration: _customLoveTheme.textFieldDecoration ??
                            const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter your password',
                            ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 327,
                      height: 56,
                      child: FilledButton(
                        onPressed: () => _controller.handleLogin(context),
                        style: _customLoveTheme.buttonStyle ??
                            ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  _customLoveTheme.primaryColor),
                            ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
