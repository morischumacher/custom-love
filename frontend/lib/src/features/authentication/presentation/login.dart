import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.pink[100], // Set your desired background color here
      appBar: AppBar(
        backgroundColor: Colors.pink[800], // Set your desired AppBar color here
        title: const Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Email'),
            const Center(
              child: SizedBox(
                width: 250,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your email address',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Password'),
            const Center(
              child: SizedBox(
                width: 250,
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter your password',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () {
                // Handle successful login
                print('Login successful');
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Colors.pink[800]), // Set your desired button color here
              ),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
