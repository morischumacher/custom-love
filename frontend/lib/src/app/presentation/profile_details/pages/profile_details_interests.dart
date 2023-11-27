import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/profile_details_location.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/widgets/page_title.dart';

class ProfileDetailsInterests extends StatefulWidget {
  const ProfileDetailsInterests({super.key});

  @override
  State<ProfileDetailsInterests> createState() => _ProfileDetailsInterestsState();
}

class _ProfileDetailsInterestsState extends State<ProfileDetailsInterests> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(21.0, 0, 21.0, 51.0),
        child: Center(
          child: Column(
            children: [
              const PageTitle(
                  title: "Your interests",
                  description: "Select a few interests and let everyone know what you're passionate about"
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
          backgroundColor: Color(0xFF953829),
          minimumSize: const Size(156, 56)
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProfileDetailsLocation(
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
          backgroundColor: Color(0xFF953829)
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
