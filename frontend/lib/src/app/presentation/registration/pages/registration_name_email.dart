import 'dart:typed_data';

import 'package:flutter/material.dart';
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
    required this.name,
    required this.email,
    required this.gender,
    required this.preference,
    required this.birthdate,
    required this.profilePicture
  });

  final String? name;
  final String? email;
  final String? gender;
  final String? preference;
  final String? birthdate;
  final Uint8List? profilePicture;

  @override
  State<RegistrationNameEmail> createState() => _RegistrationNameEmailState();
}

class _RegistrationNameEmailState extends State<RegistrationNameEmail> {
  @override
  void initState() {
    super.initState();
    usernameController.value = TextEditingValue(text: widget.name == null ? "" : widget.name as String);
    emailController.value = TextEditingValue(text: widget.email == null ? "" : widget.email as String);
    gender = widget.gender;
    preference = widget.preference;
    birthdate = widget.birthdate;
    profilePicture = widget.profilePicture;
  }

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  late String? gender;
  late String? preference;
  late String? birthdate;
  late Uint8List? profilePicture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _customLoveTheme.neutralColor,
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.fromLTRB(21.0, 0, 21.0, 51.0),
            child: Column(
              children: [
                const PageTitle(
                  title: "Profile Information",
                  description: "Provide your Name and Email",
                  bottomPadding: 70.0,
                ),
                // Name
                RegistrationTextfield(
                  controller: usernameController,
                  hintText: "Name",
                ),
                const SizedBox(height: 19.0),
                // Email
                RegistrationTextfield(
                  controller: emailController,
                  hintText: "Email",
                ),
                const Spacer(),
                // const Spacer(),
                Center(
                  child: Row(
                    children: [
                      prevBtn(context),
                      const Spacer(),
                      nextBtn(context)
                    ],
                  ),
                )

              ],
            ),
          ),
        ));

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
        "Previous",
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
            name: usernameController.value.text,
            email: emailController.value.text,
            gender: gender,
            preference: preference,
            birthdate: birthdate,
            profilePicture: profilePicture,
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
