import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_name_email.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_pictures.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/birthdate_field.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/dropdown_list.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';

import '../../../../config/theme.dart';

class RegistrationGenderPreference extends StatefulWidget {
  const RegistrationGenderPreference({
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
  State<RegistrationGenderPreference> createState() => _RegistrationGenderPreferenceState();
}

class _RegistrationGenderPreferenceState extends State<RegistrationGenderPreference> {
  @override
  void initState() {
    super.initState();
    firstName = widget.firstName;
    lastName = widget.lastName;
    email = widget.email;
    password = widget.password;
    _selectedGender = widget.gender;
    _selectedPreference = widget.preference;
    _dateController.value = TextEditingValue(text: widget.birthdate == null ? "" : widget.birthdate as String);
    profilePicture = widget.profilePicture;
    userInterestIdList = widget.userInterestIdList;
  }

  late String? firstName;
  late String? lastName;
  late String? email;
  late String? password;
  String? _selectedGender = "";
  String? _selectedPreference = "";
  late Uint8List? profilePicture;
  late Set<int> userInterestIdList;

  final TextEditingController _dateController = TextEditingController();
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final _genderList = ["Male", "Female", "Other"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _customLoveTheme.neutralColor,
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.fromLTRB(21.0, 0, 21.0, 51.0),
              child: Center(
                child: Column(
                  children: [
                    const PageTitle(
                        title: "Profile Details",
                        description: "Provide some basic data about yourself",
                        bottomPadding: 70.0,
                    ),
                    DropDownList(
                        labelText: "Gender",
                        value: _selectedGender,
                        options: _genderList,
                        setParentValueFunction: setGender
                    ),
                    const SizedBox(height: 19.0),
                    DropDownList(
                        labelText: "Preference",
                        value: _selectedPreference,
                        options: _genderList,
                        setParentValueFunction: setPreference
                    ),
                    const SizedBox(height: 19.0),
                    BirthdateField(
                        controller: _dateController,
                        context: context
                    ),
                  const SizedBox(height: 25.0),
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
              )),
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
          return RegistrationNameEmail(
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            gender: _selectedGender,
            preference: _selectedPreference,
            birthdate: _dateController.value.text,
            profilePicture: profilePicture,
            userInterestIdList: userInterestIdList
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
          return RegistrationPictures(
              firstName: firstName,
              lastName: lastName,
              email: email,
              password: password,
              gender: _selectedGender,
              preference: _selectedPreference,
              birthdate: _dateController.value.text,
              profilePicture: profilePicture,
              userInterestIdList: userInterestIdList,
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

  void setGender(String gender) {
    _selectedGender = gender;
  }

  void setPreference(String preference) {
    _selectedPreference = preference;
  }
}
