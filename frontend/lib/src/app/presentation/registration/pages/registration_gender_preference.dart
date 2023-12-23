import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/birthdate_field.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/dropdown_list.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/footer/footer.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../config/theme.dart';
import '../enums/registration_page_enum.dart';

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
    required this.userInterestIdList,
    required this.location,
    required this.searchRadius
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
  final Position? location;
  final double? searchRadius;

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
    _dateController = widget.birthdate;
    profilePicture = widget.profilePicture;
    userInterestIdList = widget.userInterestIdList;
    userLocation = widget.location;
    searchRadius = widget.searchRadius;
  }

  late String? firstName;
  late String? lastName;
  late String? email;
  late String? password;
  String? _selectedGender = "";
  String? _selectedPreference = "";
  String? _dateController;
  late Uint8List? profilePicture;
  late Set<int> userInterestIdList;
  Position? userLocation;
  late double? searchRadius;

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final _genderList = ["Male", "Female", "Other"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: _customLoveTheme.neutralColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25.0, 0, 25, 0),
            child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: CustomScrollView(
                  scrollBehavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  slivers: [
                  SliverFillRemaining(
                  hasScrollBody: false,
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
                          callback: (val) => setState(() => _selectedGender = val),
                      ),
                      const SizedBox(height: 19.0),
                      DropDownList(
                          labelText: "Preference",
                          value: _selectedPreference,
                          options: _genderList,
                          callback: (val) => setState(() => _selectedPreference = val),
                      ),
                      const SizedBox(height: 19.0),
                      BirthdateField(
                          controller: _dateController,
                          callback: (val) => setState(() => _dateController = val),
                      ),
                      Expanded(child: Container()),
                      Footer(
                          pageSection: RegistrationPageSection.genderPreference,
                          firstName: firstName,
                          lastName: lastName,
                          email: email,
                          password: password,
                          gender: _selectedGender,
                          genderPreference: _selectedPreference,
                          birthdate: _dateController,
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
          ),
        ));
  }
}
