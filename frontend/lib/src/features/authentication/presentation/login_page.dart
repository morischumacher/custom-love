import 'package:flutter/material.dart';
import 'package:frontend/src/config/theme.dart';
import 'package:frontend/src/features/authentication/application/login_service.dart';
import 'package:frontend/src/features/authentication/presentation/components/login_textfield.dart';
import 'package:frontend/src/features/authentication/presentation/components/sign_in_button.dart';
import 'package:frontend/src/features/authentication/presentation/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required LoginService loginService})
      : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final LoginController _controller = LoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _customLoveTheme.neutralColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                Text(
                  'CUSTOMLOVE',
                  style: TextStyle(
                    color: _customLoveTheme.primaryColor,
                    fontSize: 60,
                  ),
                ),

                // logo
                // tddo insert actual logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),

                const SizedBox(height: 50),

                // welcome back, you've been missed!
                Text(
                  'Welcome back you\'ve been missed!',
                  style: TextStyle(
                    color: _customLoveTheme.primaryColor,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                // email textfield
                LoginTextField(
                  controller: _controller.emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                LoginTextField(
                  controller: _controller.passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: _customLoveTheme.tertiaryColor),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // sign in button
                LoginButton(
                  onTap: () {
                    Future<void>.value(_controller.handleLogin(context));
                  },
                ),
                const SizedBox(height: 50),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style:
                              TextStyle(color: _customLoveTheme.primaryColor),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: _customLoveTheme.primaryColor),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Register now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
