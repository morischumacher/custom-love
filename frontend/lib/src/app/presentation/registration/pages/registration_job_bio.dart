import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/gender_model.dart';
import 'package:frontend/src/app/model/interest_model.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/bio_textfield.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/footer/footer.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/textfield.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

import '../../../../config/theme.dart';
import '../enums/registration_page_enum.dart';

class RegistrationJobBio extends StatefulWidget {
  RegistrationJobBio({
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
    required this.searchRadius,
    required this.job,
    required this.bio
  }) : super(key: key);

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final Gender? gender;
  final List<Gender> preference;
  final String? birthdate;
  final Uint8List? profilePicture;
  final List<Interest> userInterestIdList;
  final Position? location;
  final double? searchRadius;
  late String? job;
  late String? bio;

  @override
  State<RegistrationJobBio> createState() => _RegistrationJobBioState();
}

class _RegistrationJobBioState extends State<RegistrationJobBio> {
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final logger = Logger();

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
                scrollBehavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: <Widget>[
                        const PageTitle(
                          title: "Profile Bio",
                          description: "Please specify your job and bio",
                          bottomPadding: 70.0,
                        ),
                        RegistrationTextfield(
                            controller: widget.job,
                            hintText: "Job",
                            obscureText: false,
                            callback: (val) => setState(() => widget.job = val)
                        ),
                        const SizedBox(height: 19.0),
                        RegistrationBioTextfield(
                            controller: widget.bio,
                            hintText: "Bio",
                            characterLimit: 256,
                            callback: (val) => setState(() => widget.bio = val)
                        ),

                        const SizedBox(height: 25.0),
                        Expanded(child: Container()),
                        Footer(
                            pageSection: RegistrationPageSection.jobBio,
                            firstName: widget.firstName,
                            lastName: widget.lastName,
                            email: widget.email,
                            password: widget.password,
                            gender: widget.gender,
                            genderPreference: widget.preference,
                            birthdate: widget.birthdate,
                            profilePicture: widget.profilePicture,
                            userInterestIdList: widget.userInterestIdList,
                            location: widget.location,
                            searchRadius: widget.searchRadius,
                            job: widget.job,
                            bio: widget.bio
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )

    );

  }
}
