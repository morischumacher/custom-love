import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/gender_model.dart';
import 'package:frontend/src/app/model/interest_model.dart';
import 'package:frontend/src/app/presentation/registration/enums/registration_page_enum.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../../config/theme.dart';
import 'navigation_button.dart';

class Footer extends StatefulWidget {
  const Footer({
    super.key,
    required this.pageSection,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.gender,
    required this.genderPreference,
    required this.birthdate,
    required this.profilePicture,
    required this.userInterestIdList,
    required this.location,
    required this.searchRadius
  });

  final RegistrationPageSection pageSection;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final Gender? gender;
  final Gender? genderPreference;
  final String? birthdate;
  final Uint8List? profilePicture;
  final List<Interest> userInterestIdList;
  final Position? location;
  final double? searchRadius;

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Row(
            children: [
              NavigationButton(
                  nextPage: widget.pageSection.predecessor,
                  btnText: widget.pageSection.predecessor != RegistrationPageSection.login ? 'Previous' : 'Login',
                  firstName: widget.firstName,
                  lastName: widget.lastName,
                  email: widget.email,
                  password: widget.password,
                  gender: widget.gender,
                  genderPreference: widget.genderPreference,
                  birthdate: widget.birthdate,
                  profilePicture: widget.profilePicture,
                  userInterestIdList: widget.userInterestIdList,
                  location: widget.location,
                  searchRadius: widget.searchRadius
              ),
              const Spacer(),
              if (evaluateBtnAccessibility())
                NavigationButton(
                    nextPage: widget.pageSection.successor,
                    btnText: widget.pageSection.successor != RegistrationPageSection.submit ? 'Next' : 'Submit',
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    password: widget.password,
                    gender: widget.gender,
                    genderPreference: widget.genderPreference,
                    birthdate: widget.birthdate,
                    profilePicture: widget.profilePicture,
                    userInterestIdList: widget.userInterestIdList,
                    location: widget.location,
                    searchRadius: widget.searchRadius
                ),
              if (!evaluateBtnAccessibility())
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: _customLoveTheme.grayscale1,
                    foregroundColor: _customLoveTheme.textColor,
                    minimumSize: const Size(156, 56),
                  ),
                  onPressed: () {  },
                  child: const Text("Next"),
                )
            ],
          ),
        ),
        const SizedBox(height: 30.0),
        Center(
            child: Column(
              children: [
                InkWell(
                  child: Text(
                    'Return to Login',
                    style: TextStyle(
                      color: _customLoveTheme.linkColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/");
                  },
                ),
                const SizedBox(height: 30)
              ],
            )
        )
      ],
    );

  }
  
  bool evaluateBtnAccessibility() {
    switch(widget.pageSection) {
      case RegistrationPageSection.location:
        return widget.location != null;
      case RegistrationPageSection.radius:
        return widget.searchRadius != null;
      case RegistrationPageSection.nameEmail:
        return widget.firstName != null &&
            widget.firstName!.trim().isNotEmpty &&
            widget.lastName != null && 
            widget.lastName!.trim().isNotEmpty &&
            widget.lastName != null &&
            widget.email != null &&
            widget.email!.trim().isNotEmpty &&
            widget.password != null &&
            widget.password!.trim().isNotEmpty;
      case RegistrationPageSection.genderPreference:
        return widget.gender != null && 
            widget.genderPreference != null && 
            widget.birthdate != null;
      case RegistrationPageSection.pictures:
        return widget.profilePicture != null;
        // TODO: Are interests required?
        // return widget.userInterestIdList.length != 0;
      case RegistrationPageSection.interests:
        return true;
      case RegistrationPageSection.summary:
        return true;
      default:
        return false;
    }
  }
}
