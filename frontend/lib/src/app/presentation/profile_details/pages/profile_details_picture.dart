import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/profile_details.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/profile_details_location.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/widgets/page_title.dart';

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

  final String? gender;
  final String? preference;
  final String? dob;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(21.0, 0, 21.0, 0),
        child: Center(
          child: Column(
            children: [
              const PageTitle(
                  title: "Profile Pictures",
                  description: "Provide up to five pictures of yourself"
              ),
              Center(
                child: Row(
                  children: [
                    prevBtn(context),
                    const Spacer(),
                    nextBtn(context)
                  ],
                ),
              )

              // "Previous"- or "Next"-buttons
            ],
          ),
        )
    );
  }

  OutlinedButton prevBtn(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          backgroundColor: Color(0xFF953829),
          minimumSize: const Size(156, 56)
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
          backgroundColor: Color(0xFF953829)
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProfileDetailsLocation(
          );
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
