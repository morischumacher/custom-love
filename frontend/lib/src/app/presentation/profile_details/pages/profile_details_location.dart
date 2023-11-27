import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/profile_details_interests.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/profile_details_picture.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/widgets/page_title.dart';

class ProfileDetailsLocation extends StatefulWidget {
  const ProfileDetailsLocation({super.key});

  @override
  State<ProfileDetailsLocation> createState() => _ProfileDetailsLocationState();
}

class _ProfileDetailsLocationState extends State<ProfileDetailsLocation> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(21.0, 0, 21.0, 51.0),
        child: Center(
          child: Column(
            children: [
              const PageTitle(
                  title: "Location",
                  description: "Provide information about your location"
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
    );

  }

  OutlinedButton prevBtn(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFF953829),
          minimumSize: const Size(156, 56)
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProfileDetailsPicture(
              gender: null,
              preference: null,
              dob: null
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
          backgroundColor: const Color(0xFF953829)
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
