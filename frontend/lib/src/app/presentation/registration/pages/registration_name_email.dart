import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/registration/controller/registration_controller.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_gender_preference.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/textfield.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme.dart';
import '../../../service/login_service.dart';
import '../../../service/user_service.dart';
import '../../authentification/pages/login_page.dart';

class RegistrationNameEmail extends StatefulWidget {
  const RegistrationNameEmail({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.gender,
    required this.preference,
    required this.birthdate,
    required this.profilePicture,
    required this.userInterestIdList
  });

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? gender;
  final String? preference;
  final String? birthdate;
  final Uint8List? profilePicture;
  final Set<int> userInterestIdList;

  @override
  State<RegistrationNameEmail> createState() => _RegistrationNameEmailState();
}

class _RegistrationNameEmailState extends State<RegistrationNameEmail> {
  final RegistrationController _controller = RegistrationController();

  @override
  void initState() {
    super.initState();
    firstName.value = TextEditingValue(text: widget.firstName == null ? "" : widget.firstName as String);
    lastName.value = TextEditingValue(text: widget.lastName == null ? "" : widget.lastName as String);
    emailController.value = TextEditingValue(text: widget.email == null ? "" : widget.email as String);
    passwordController.value = TextEditingValue(text: widget.password == null ? "" : widget.password as String);
    gender = widget.gender;
    preference = widget.preference;
    birthdate = widget.birthdate;
    profilePicture = widget.profilePicture;
    userInterestIdList = widget.userInterestIdList;

    print("registration_name_email.dart");
    print(_controller.userLocation);
    print("=========");
  }

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late String? gender;
  late String? preference;
  late String? birthdate;
  late Uint8List? profilePicture;
  late Set<int> userInterestIdList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _customLoveTheme.neutralColor,
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(25.0, 0, 25.0, 51.0),
                child: Column(
                  children: [
                    const PageTitle(
                      title: "Profile Name",
                      description: "Provide your first name and last name",
                      bottomPadding: 70.0,
                    ),
                    // Name
                    RegistrationTextfield(
                      controller: firstName,
                      hintText: "First Name",
                      obscureText: false,
                    ),
                    const SizedBox(height: 19.0),
                    RegistrationTextfield(
                      controller: lastName,
                      hintText: "Last Name",
                      obscureText: false,
                    ),
                    const SizedBox(height: 19.0),
                    // Email
                    RegistrationTextfield(
                      controller: emailController,
                      hintText: "Email",
                      obscureText: false,
                    ),
                    const SizedBox(height: 19.0),
                    // Email
                    RegistrationTextfield(
                      controller: passwordController,
                      hintText: "Password",
                      obscureText: true,
                    ),
                    const SizedBox(height: 25.0),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Center(
                        child: Row(
                          children: [
                            const SizedBox(height: 80),
                            prevBtn(context),
                            const Spacer(),
                            nextBtn(context)
                          ],
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        );

  }

  OutlinedButton prevBtn(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          minimumSize: const Size(156, 56),
          backgroundColor: _customLoveTheme.primaryColor,
          side: BorderSide.none
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return LoginPage(
            loginService: Provider.of<LoginService>(context),
            userService: Provider.of<UserService>(context),
          );
        }));
      },
      child: const Text(
        "Return",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
    );
  }

  OutlinedButton nextBtn(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          minimumSize: const Size(156, 56),
          backgroundColor: _customLoveTheme.primaryColor,
          side: BorderSide.none
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RegistrationGenderPreference(
            firstName: firstName.value.text,
            lastName: lastName.value.text,
            email: emailController.value.text,
            password: passwordController.value.text,
            gender: gender,
            preference: preference,
            birthdate: birthdate,
            profilePicture: profilePicture,
            userInterestIdList: userInterestIdList
          );
        }));
      },
      child: const Text(
        "Next",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
    );
  }
}
