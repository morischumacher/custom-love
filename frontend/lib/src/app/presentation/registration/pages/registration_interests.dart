import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/footer/footer.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/interest_button.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';
import 'package:frontend/src/app/service/interest_service.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../config/theme.dart';
import '../../../service/gender_service.dart';
import '../enums/registration_page_enum.dart';

class RegistrationInterests extends StatefulWidget {
  const RegistrationInterests({
    Key? key,
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
  final Gender? gender;
  final Gender? preference;
  final String? birthdate;
  final Uint8List? profilePicture;
  final List<Interest> userInterestIdList;
  final Position? location;
  final double? searchRadius;

  @override
  State<RegistrationInterests> createState() => _RegistrationInterestsState();
}

class _RegistrationInterestsState extends State<RegistrationInterests> {
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
    searchRadius = widget.searchRadius;
    getInterests();
  }

  void getInterests() async {
    await _interestService.getInterests().then((value) {
      setState(() {
        interestDto = value;
      });
    });
  }

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final InterestService _interestService = InterestService();
  late String? firstName;
  late String? lastName;
  late String? email;
  late String? password;
  late Gender? gender;
  late Gender? preference;
  late String? birthdate;
  late Uint8List? profilePicture;
  late List<Interest> userInterestIdList = [];
  Position? userLocation;
  late double? searchRadius;

  late List<Interest> interestDto = [];

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
                      title: "Your interests",
                      description: "Select a few interests you're passionate about",
                      bottomPadding: 49.0
                  ),
                  if (interestDto.isEmpty)
                    SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator(
                          color: _customLoveTheme.primaryColor,
                          strokeWidth: 18
                        )
                    ),
                  if (interestDto.isNotEmpty)
                  for (int i = 0; i < interestDto.length; i += 2)
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: InterestButton(
                                      interest: interestDto[i],
                                      containsInterestFunction: containsInterest,
                                      addRemoveInterestFunction: addRemoveInterest
                                  ),
                                ),
                                const SizedBox(width: 20),
                                if (i + 1 < interestDto.length)
                                  Expanded(
                                  child: InterestButton(
                                    interest: interestDto[i + 1],
                                    containsInterestFunction: containsInterest,
                                      addRemoveInterestFunction: addRemoveInterest
                                  ),
                                ) else Expanded(child: Container()),
                              ],
                            ),
                      ),
                    ),
                  const SizedBox(height: 25.0),
                  Expanded(child: Container()),
                  Footer(
                      pageSection: RegistrationPageSection.interests,
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
        ),
        ));

  }

  bool containsInterest(Interest interest) {
    return userInterestIdList.contains(interest);
  }

  void addRemoveInterest(Interest interest) {
    containsInterest(interest) ?
    userInterestIdList.removeWhere((thisInterest) => interest.id == thisInterest.id) :
    userInterestIdList.add(interest);
  }
}
