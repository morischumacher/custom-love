import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/profile_details_picture.dart';
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

  final interestIconMapping = {
    "photography": const Icon(Icons.photo_camera),
    "shopping": const Icon(Icons.shopping_bag),
    "karaoke": const Icon(Icons.mic_rounded),
    "tennis": const Icon(Icons.sports_tennis)
};

  final interestSelectMapping = {
    "photography": false,
    "shopping": false,
    "karaoke": false,
    "tennis": false
  };

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
                          child: ElevatedButton.icon(
                            // child: const Text("Shopping"),
                              icon: Icon(Icons.photo_camera, color: interestSelectMapping["photography"] == true ? Colors.white : _customLoveTheme.tertiaryColor),
                              label: const Text("Photography"),
                              onPressed: () {
                                setState(() {
                                  interestSelectMapping["photography"] = !interestSelectMapping["photography"]!;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(20.0),
                                  backgroundColor: interestSelectMapping["photography"] == true ? _customLoveTheme.selected : Colors.white,
                                  foregroundColor:interestSelectMapping["photography"] == true ? Colors.white : _customLoveTheme.tertiaryColor,
                                  elevation: 15,
                                  shadowColor: Colors.black,
                                  alignment: Alignment.center,
                                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                  shape: StadiumBorder(
                                      side: BorderSide(
                                        width: 2,
                                        color: interestSelectMapping["photography"] == true ? Colors.white : _customLoveTheme.tertiaryColor
                                      )
                                  ),
                                  textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                  ),
                              )
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton.icon(
                            // child: const Text("Shopping"),
                            icon: const Icon(Icons.shopping_bag),
                            label: const Text("Shopping"),
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(20.0),
                              backgroundColor:  _customLoveTheme.tertiaryColor,
                              foregroundColor: Colors.white,
                              elevation: 15,
                              shadowColor: Colors.black,
                              alignment: Alignment.center,
                              // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                shape: const StadiumBorder(),
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold
                              )
                            )
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
                          child: ElevatedButton.icon(
                            // child: const Text("Shopping"),
                              icon: const Icon(Icons.mic_rounded),
                              label: const Text("Karaoke"),
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(20.0),
                                  backgroundColor:  _customLoveTheme.tertiaryColor,
                                  foregroundColor: Colors.white,
                                  elevation: 15,
                                  shadowColor: Colors.black,
                                  alignment: Alignment.center,
                                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                  shape: const StadiumBorder(),
                                  textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                  )
                              )
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton.icon(
                            // child: const Text("Shopping"),
                              icon: const Icon(Icons.sports_tennis),
                              label: const Text("Tennis"),
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(20.0),
                                  backgroundColor: _customLoveTheme.tertiaryColor,
                                  foregroundColor: Colors.white,
                                  elevation: 15,
                                  shadowColor: Colors.black,
                                  alignment: Alignment.center,
                                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                  shape: const StadiumBorder(),
                                  textStyle: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                  )
                              )
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
