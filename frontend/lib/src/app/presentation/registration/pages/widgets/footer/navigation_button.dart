import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/authentification/pages/login_page.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_gender_preference.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_interests.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_location.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_pictures.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_radius.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_summary.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../../../../../config/theme.dart';
import '../../../../../service/login_service.dart';
import '../../../../../service/user_service.dart';
import '../../../controller/registration_controller.dart';
import '../../../enums/registration_page_enum.dart';
import '../../registration_name_email.dart';

class NavigationButton extends StatefulWidget {
  const NavigationButton({
    super.key,
    required this.nextPage,
    required this.btnText,

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

  final RegistrationPageSection nextPage;
  final String btnText;

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? gender;
  final String? genderPreference;
  final String? birthdate;
  final Uint8List? profilePicture;
  final Set<int> userInterestIdList;
  final Position? location;
  final double? searchRadius;

  @override
  State<NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<NavigationButton> {
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final RegistrationController _controller = RegistrationController();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          minimumSize: const Size(156, 56),
          backgroundColor: _customLoveTheme.primaryColor,
          side: BorderSide.none
      ),
      onPressed: () {
        if (widget.nextPage == RegistrationPageSection.submit) {
          Future<void>.value(
              _controller.handleRegistration(
              context,
              widget.firstName,
              widget.lastName,
              widget.email,
              widget.password,
              "",
              widget.birthdate,
              "",
              widget.searchRadius,
              widget.gender,
              widget.genderPreference,
              widget.profilePicture,
              widget.userInterestIdList,
              1
            )
          );
        } else {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            switch(widget.nextPage) {
              case RegistrationPageSection.login:
                return LoginPage(
                    loginService: Provider.of<LoginService>(context),
                    userService: Provider.of<UserService>(context)
                );
              case RegistrationPageSection.location:
                return RegistrationLocation(
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    password: widget.password,
                    gender: widget.gender,
                    preference: widget.genderPreference,
                    birthdate: widget.birthdate,
                    profilePicture: widget.profilePicture,
                    userInterestIdList: widget.userInterestIdList,
                    location: widget.location,
                    searchRadius: widget.searchRadius
                );
              case RegistrationPageSection.radius:
                return RegistrationRadius(
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    password: widget.password,
                    gender: widget.gender,
                    preference: widget.genderPreference,
                    birthdate: widget.birthdate,
                    profilePicture: widget.profilePicture,
                    userInterestIdList: widget.userInterestIdList,
                    location: widget.location,
                    searchRadius: widget.searchRadius
                );
              case RegistrationPageSection.nameEmail:
                return RegistrationNameEmail(
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    password: widget.password,
                    gender: widget.gender,
                    preference: widget.genderPreference,
                    birthdate: widget.birthdate,
                    profilePicture: widget.profilePicture,
                    userInterestIdList: widget.userInterestIdList,
                    location: widget.location,
                    searchRadius: widget.searchRadius
                );
              case RegistrationPageSection.genderPreference:
                return RegistrationGenderPreference(
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    password: widget.password,
                    gender: widget.gender,
                    preference: widget.genderPreference,
                    birthdate: widget.birthdate,
                    profilePicture: widget.profilePicture,
                    userInterestIdList: widget.userInterestIdList,
                    location: widget.location,
                    searchRadius: widget.searchRadius
                );
              case RegistrationPageSection.pictures:
                return RegistrationPictures(
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    password: widget.password,
                    gender: widget.gender,
                    preference: widget.genderPreference,
                    birthdate: widget.birthdate,
                    profilePicture: widget.profilePicture,
                    userInterestIdList: widget.userInterestIdList,
                    location: widget.location,
                    searchRadius: widget.searchRadius
                );
              case RegistrationPageSection.interests:
                return RegistrationInterests(
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    password: widget.password,
                    gender: widget.gender,
                    preference: widget.genderPreference,
                    birthdate: widget.birthdate,
                    profilePicture: widget.profilePicture,
                    userInterestIdList: widget.userInterestIdList,
                    location: widget.location,
                    searchRadius: widget.searchRadius
                );
              case RegistrationPageSection.summary:
                return RegistrationSummary(
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    password: widget.password,
                    gender: widget.gender,
                    preference: widget.genderPreference,
                    birthdate: widget.birthdate,
                    profilePicture: widget.profilePicture,
                    userInterestIdList: widget.userInterestIdList,
                    location: widget.location,
                    searchRadius: widget.searchRadius
                );
              default:
                return RegistrationLocation(
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    email: widget.email,
                    password: widget.password,
                    gender: widget.gender,
                    preference: widget.genderPreference,
                    birthdate: widget.birthdate,
                    profilePicture: widget.profilePicture,
                    userInterestIdList: widget.userInterestIdList,
                    location: widget.location,
                    searchRadius: widget.searchRadius
                );
            }
          }));
        }
      },
      child: Text(
        widget.btnText,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
    );
  }
}
