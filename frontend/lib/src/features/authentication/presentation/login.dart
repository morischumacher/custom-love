import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
            padding: EdgeInsets.all(16.0), // Add padding for spacing
            child: Text(
              'Welcome to Custom Love App',
              style: TextStyle(
                fontSize: 24, // Adjust the font size as needed
                fontWeight: FontWeight.bold, // Add bold styling if desired
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
                      controller: emailController,
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
                      controller: passwordController,
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
                      onPressed: () {
                        // Handle login with email and password
                        String email = emailController.text;
                        String password = passwordController.text;
                        if (email.isNotEmpty && password.isNotEmpty) {
                          // Valid email and password, proceed with login
                          print('Login successful');
                          Navigator.pushNamed(context, '/home');
                        } else {
                          // Display an error message or validation
                          print(
                              'Login failed. Please enter a valid email and password.');
                        }
                      },
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
