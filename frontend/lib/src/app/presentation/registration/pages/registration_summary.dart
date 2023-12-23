import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/footer/footer.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/summary_textfield.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

import '../../../../config/theme.dart';
import '../enums/registration_page_enum.dart';

class RegistrationSummary extends StatefulWidget {
  const RegistrationSummary({Key? key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.gender,
    required this.preference,
    required this.birthdate,
    required this.profilePicture,
    required this.userInterestIdList,
    required this.location,
    required this.searchRadius
  }) : super(key: key);

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? gender;
  final String? preference;
  final String? birthdate;
  final Uint8List? profilePicture;
  final Set<int> userInterestIdList;
  final Position? location;
  final double? searchRadius;

  @override
  State<RegistrationSummary> createState() => _RegistrationSummaryState();
}

class _RegistrationSummaryState extends State<RegistrationSummary> {
  @override
  void initState() {
    super.initState();
    firstName = widget.firstName;
    lastName = widget.lastName;
    email = widget.email;
    password = widget.password;
    gender = widget.gender;
    preference = widget.preference;
    birthdate = widget.birthdate;
    profilePicture = widget.profilePicture;
    userInterestIdList = widget.userInterestIdList;
    userLocation = widget.location;
    searchRadius = widget.searchRadius ?? 1;
  }

  final logger = Logger();
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  late String? firstName;
  late String? lastName;
  late String? email;
  late String? password;
  late String? gender;
  late String? preference;
  late String? birthdate;
  Uint8List? profilePicture;
  late Set<int> userInterestIdList;
  Position? userLocation;
  late double? searchRadius;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _customLoveTheme.neutralColor,
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: CustomScrollView(
              scrollBehavior:
              ScrollConfiguration.of(context).copyWith(scrollbars: false),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: <Widget>[
                      const PageTitle(
                        title: "Profile Summary",
                        description: "Please check if your profile details are correct",
                        bottomPadding: 70.0,
                      ),
                      const SizedBox(height: 15.0),
                      SummaryTextfield(label: "First name", input: firstName!),
                      SummaryTextfield(label: "Last name", input: lastName!),
                      SummaryTextfield(label: "Email", input: email!),
                      SummaryTextfield(label: "Password", input: password!),
                      SummaryTextfield(label: "Gender", input: gender!),
                      SummaryTextfield(label: "Gender Preference", input: preference!),
                      SummaryTextfield(label: "Birthdate", input: birthdate!),
                      SummaryTextfield(label: "Search Radius", input: searchRadius!.toString()),
                      // TODO: Add remaining input fields
                      Expanded(child: Container()),
                      Footer(
                          pageSection: RegistrationPageSection.summary,
                          firstName: firstName,
                          lastName: lastName,
                          email: email,
                          password: password,
                          gender: gender,
                          genderPreference: preference,
                          birthdate: birthdate,
                          profilePicture: profilePicture,
                          userInterestIdList: userInterestIdList,
                          location: userLocation,
                          searchRadius: searchRadius
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
