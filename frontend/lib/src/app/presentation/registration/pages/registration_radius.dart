import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_location.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_name_email.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

import '../../../../config/theme.dart';

class RegistrationRadius extends StatefulWidget {
  const RegistrationRadius({Key? key,
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
  State<RegistrationRadius> createState() => _RegistrationRadiusState();
}

class _RegistrationRadiusState extends State<RegistrationRadius> {
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
    searchRadiusMiles = searchRadius != null ? (searchRadius! * 0.621371).roundToDouble() : 1;
  }

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final logger = Logger();

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
  // Default searchRadius is in km
  late double? searchRadius; double? searchRadiusMiles;

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
                        title: "Profile Matching Radius",
                        description: "Set your radius for potential Matches",
                        bottomPadding: 70.0,
                      ),
                      const SizedBox(height: 15.0),
                      Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: TextStyle(
                                color: _customLoveTheme.primaryColor,
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold
                              ),
                              children: <TextSpan>[
                                TextSpan(text: searchRadius!.toString()),
                                TextSpan(
                                    text: searchRadius != 1 ? '  kilometers' : '  kilometer',
                                    style: TextStyle(
                                        color: _customLoveTheme.textColor)
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          RichText(
                            text: TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: TextStyle(
                                  color: _customLoveTheme.primaryColor,
                                  fontSize: 32.0,
                                  fontWeight: FontWeight.bold
                              ),
                              children: <TextSpan>[
                                TextSpan(text: searchRadiusMiles.toString()),
                                TextSpan(
                                    text: searchRadiusMiles != 1 ? '  miles' : '  mile',
                                    style: TextStyle(
                                        color: _customLoveTheme.textColor)
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 50.0),
                          Slider(
                              min: 1,
                              max: 100,
                              divisions: 99,
                              label: searchRadius!.toString(),
                              value: searchRadius!,
                              activeColor: _customLoveTheme.primaryColor,
                              onChanged: (value) {
                                setState(() {
                                  searchRadius = value.roundToDouble();
                                  searchRadiusMiles = (value * 0.621371).roundToDouble();
                                });
                              }),
                        ],
                      ),
                      Expanded(child: Container()),
                      Center(
                        child: Row(
                          children: [
                            prevBtn(context),
                            const Spacer(),
                            nextBtn(context),
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
                      ))
                    ],
                  ),
                ),
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
          side: BorderSide.none),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RegistrationLocation(
              firstName: firstName,
              lastName: lastName,
              email: email,
              password: password,
              gender: gender,
              preference: preference,
              birthdate: birthdate,
              profilePicture: profilePicture,
              userInterestIdList: userInterestIdList,
              location: userLocation,
              searchRadius: searchRadius
          );
        }));
      },
      child: const Text(
        "Return",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  OutlinedButton nextBtn(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          minimumSize: const Size(156, 56),
          backgroundColor: _customLoveTheme.primaryColor,
          side: BorderSide.none),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RegistrationNameEmail(
              firstName: firstName,
              lastName: lastName,
              email: email,
              password: password,
              gender: gender,
              preference: preference,
              birthdate: birthdate,
              profilePicture: profilePicture,
              userInterestIdList: userInterestIdList,
              location: userLocation,
              searchRadius: searchRadius
          );
        }));
      },
      child: const Text(
        "Next",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
