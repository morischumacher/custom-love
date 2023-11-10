import 'package:flutter/material.dart';
import 'login_controller.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginController _controller = LoginController();

  double inputWidth = 327;
  double inputHeight = 56;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Love App'),
        backgroundColor: Colors.pink[800],
      ),
      body: Column(
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
                    width: inputWidth,
                    height: inputHeight,
                    child: TextField(
                      key: const Key('emailTextField'),
                      controller: _controller.emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter your email address',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: inputWidth,
                    height: inputHeight,
                    child: TextField(
                      key: const Key('passwordTextField'),
                      controller: _controller.passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter your password',
                      ),
                    ),
                  ),
                  const SizedBox(
                      height: 20), // Add spacing between form and button
                  SizedBox(
                    width: 327,
                    height: 56,
                    child: FilledButton(
                      onPressed: () => _controller.handleLogin(context),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.pink[800]),
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
    );
  }
}
