import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/profile_details.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/profile_details_interests.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/profile_details_location.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/widgets/page_title.dart';

import '../../../../config/theme.dart';

class ProfileDetailsPicture extends StatefulWidget {
  // const ProfileDetailsPicture({super.key});
  const ProfileDetailsPicture({
    Key? key,
    required this.gender,
    required this.preference,
    required this.dob
  }) : super(key: key);

  final String? gender;
  final String? preference;
  final String? dob;


  @override
  State<ProfileDetailsPicture> createState() => _ProfileDetailsPictureState(
      gender: gender,
      preference: preference,
      dob: dob
  );
}

class _ProfileDetailsPictureState extends State<ProfileDetailsPicture> {
  _ProfileDetailsPictureState({
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
      body: Center(
        child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            color: _customLoveTheme.neutralColor,
            padding: const EdgeInsets.fromLTRB(21.0, 0, 21.0, 51.0),
            child: Center(
              child: Column(
                children: [
                  const PageTitle(
                      title: "Profile Pictures",
                      description: "Provide up to five pictures of yourself",
                      bottomPadding: 150.0,
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
          return ProfileDetails();
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
          return ProfileDetailsInterests();
        }));
      },
      child: const Text(
        "Next",
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
    );
  }
}
