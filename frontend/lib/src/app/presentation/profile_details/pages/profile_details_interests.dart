import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/profile_details_picture.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/widgets/interest.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/widgets/page_title.dart';

import '../../../../config/theme.dart';

class ProfileDetailsInterests extends StatefulWidget {
  const ProfileDetailsInterests({
    Key? key,
    required this.gender,
    required this.preference,
    required this.dob
  }) : super(key: key);

  final String? gender;
  final String? preference;
  final String? dob;

  @override
  State<ProfileDetailsInterests> createState() => _ProfileDetailsInterestsState(
    dob: dob,
    gender: gender,
    preference: preference
  );
}

class _ProfileDetailsInterestsState extends State<ProfileDetailsInterests> {
  _ProfileDetailsInterestsState({
    required this.gender,
    required this.preference,
    required this.dob
  });

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final String? gender;
  final String? preference;
  final String? dob;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _customLoveTheme.neutralColor,
      body: Container(
          padding: const EdgeInsets.fromLTRB(21.0, 0, 21.0, 51.0),
          child: Center(
            child: Column(
              children: [
                const PageTitle(
                    title: "Your interests",
                    description: "Select a few interests and let everyone know what you're passionate about",
                    bottomPadding: 49.0
                ),
                Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Interest(
                              interestName: "Photography",
                              icon: Icons.photo_camera
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Interest(
                              interestName: "Shopping",
                              icon: Icons.shopping_bag
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 21.0),
                Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Interest(
                              interestName: "Karaoke",
                              icon: Icons.mic_rounded
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Interest(
                              interestName: "Tennis",
                              icon: Icons.sports_tennis
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
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
          )
      ),
    );

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
          return ProfileDetailsPicture(
            dob: dob,
            gender: gender,
            preference: preference,
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
        /*
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProfileDetailsInterests();
        }));
         */
      },
      child: const Text(
        "Create Profile",
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
    );
  }
}
