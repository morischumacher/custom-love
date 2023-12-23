import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/footer/footer.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/interest.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../config/theme.dart';
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
  final String? gender;
  final String? preference;
  final String? birthdate;
  final Uint8List? profilePicture;
  final Set<int> userInterestIdList;
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
  }

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  late String? firstName;
  late String? lastName;
  late String? email;
  late String? password;
  late String? gender;
  late String? preference;
  late String? birthdate;
  late Uint8List? profilePicture;
  late Set<int> userInterestIdList;
  Position? userLocation;
  late double? searchRadius;

  final interestDto = [
    {"id": 1, "name": "sports"},
    {"id": 2, "name": "movies"},
    {"id": 3, "name": "travel"},
    {"id": 4, "name": "science"},
    {"id": 5, "name": "books"},
    {"id": 6, "name": "music"},
    {"id": 7, "name": "art"},
    {"id": 8, "name": "food"},
    {"id": 9, "name": "technology"},
    {"id": 10, "name": "fashion"},
    {"id": 11, "name": "photography"},
    {"id": 12, "name": "gaming"},
    {"id": 13, "name": "nature"},
    {"id": 14, "name": "history"},
    {"id": 15, "name": "fitness"},
    {"id": 16, "name": "crafts"},
    {"id": 17, "name": "writing"},
    {"id": 18, "name": "gardening"},
    {"id": 19, "name": "philosophy"},
    {"id": 20, "name": "coding"}
  ];

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
                  for (int i = 0; i < interestDto.length; i += 2)
                    Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Interest(
                                      interestId: interestDto[i]['id'] as int,
                                      interestName: interestDto[i]['name'].toString(),
                                      containsInterestFunction: containsInterest,
                                      addRemoveInterestFunction: addRemoveInterest
                                  ),
                                ),
                                const SizedBox(width: 20),
                                if (i + 1 < interestDto.length)
                                  Expanded(
                                  child: Interest(
                                    interestId: interestDto[i + 1]['id'] as int,
                                    interestName: interestDto[i + 1]['name'].toString(),
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

  bool containsInterest(int id) {
    return userInterestIdList.contains(id);
  }

  void addRemoveInterest(int id) {
    containsInterest(id) ?
    userInterestIdList.removeWhere((interestId) => interestId == id) :
    userInterestIdList.add(id);
  }
}
