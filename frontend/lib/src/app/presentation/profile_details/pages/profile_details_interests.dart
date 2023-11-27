import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/profile_details_location.dart';

class ProfileDetailsInterests extends StatefulWidget {
  const ProfileDetailsInterests({super.key});

  @override
  State<ProfileDetailsInterests> createState() => _ProfileDetailsInterestsState();
}

class _ProfileDetailsInterestsState extends State<ProfileDetailsInterests> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(21.0, 0, 21.0, 0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 51.0),
              SizedBox(
                  child: Text("Your interests",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 34.0,
                          color: Colors.black,
                          decoration: TextDecoration.none))),
              SizedBox(
                  child: Text("Select a few interests and let everyone know what you're passionate about",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF797C7B), // Colors.white70
                        decoration: TextDecoration.none,
                        fontStyle: FontStyle.italic,
                      ))),
              const SizedBox(height: 150.0),
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
