import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/home/pages/home.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_pictures.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/interest.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';
import 'package:frontend/src/app/service/user_service.dart';
import 'package:provider/provider.dart';

import '../../../../config/theme.dart';

class RegistrationInterests extends StatefulWidget {
  const RegistrationInterests({
    Key? key,
    required this.gender,
    required this.preference,
    required this.birthdate
  }) : super(key: key);

  final String? gender;
  final String? preference;
  final String? birthdate;

  @override
  State<RegistrationInterests> createState() => _RegistrationInterestsState(
      birthdate: birthdate,
    gender: gender,
    preference: preference
  );
}

class _RegistrationInterestsState extends State<RegistrationInterests> {
  _RegistrationInterestsState({
    required this.birthdate,
    required this.gender,
    required this.preference
  });

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final String? gender;
  final String? preference;
  final String? birthdate;

  final interestDto = [
    {'icon_code': 0xe4b6, 'font_family': 'MaterialIcons', 'interest_name': 'Photography'},
    {'icon_code': 0xe59a, 'font_family': 'MaterialIcons', 'interest_name': 'Shopping'},
    {'icon_code': 0xf8bd, 'font_family': 'MaterialIcons', 'interest_name': 'Karaoke'},
    {'icon_code': 0xe5f3, 'font_family': 'MaterialIcons', 'interest_name': 'Tennis'},
    {'icon_code': 0xe39b, 'font_family': 'MaterialIcons', 'interest_name': 'Movies'},
    {'icon_code': 0xe5e3, 'font_family': 'MaterialIcons', 'interest_name': 'Sports'},
    {'icon_code': 0xe5e4, 'font_family': 'MaterialIcons', 'interest_name': 'Bars'},
    {'icon_code': 0xf02ee, 'font_family': 'MaterialIcons', 'interest_name': 'Travel'}, // 0xf02ee
    {'icon_code': 0xe0ef, 'font_family': 'MaterialIcons', 'interest_name': 'Book'},
    {'icon_code': 0xe55a, 'font_family': 'MaterialIcons', 'interest_name': 'Science'},
    {'icon_code': 0xf06c3, 'font_family': 'MaterialIcons', 'interest_name': 'Yoga'},
    {'icon_code': 0xe28e, 'font_family': 'MaterialIcons', 'interest_name': 'LGBTQ rights'},
    {'icon_code': 0xe67c, 'font_family': 'MaterialIcons', 'interest_name': 'Road trips'},
    {'icon_code': 0xf32c, 'font_family': 'MaterialIcons', 'interest_name': 'Jogging'},
    {'icon_code': 0xe1d3, 'font_family': 'MaterialIcons', 'interest_name': 'Jetski'},
    {'icon_code': 0xe2f2, 'font_family': 'MaterialIcons', 'interest_name': 'Social Justice'},
    {'icon_code': 0xe4c1, 'font_family': 'MaterialIcons', 'interest_name': 'NFTs'},
    {'icon_code': 0xeede, 'font_family': 'MaterialIcons', 'interest_name': 'Marvel'},
    {'icon_code': 0xf03dd, 'font_family': 'MaterialIcons', 'interest_name': 'Gym'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _customLoveTheme.neutralColor,
      body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(21.0, 0, 21.0, 51.0),
          child: Center(
            child: Column(
              children: [
                const PageTitle(
                    title: "Your interests",
                    description: "Select a few interests and let everyone know what you're passionate about",
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
                                    interestName: interestDto[i]['interest_name'].toString(),
                                    iconCode: int.parse(interestDto[i]['icon_code'].toString()),
                                    fontFamily: interestDto[i]['font_family'].toString(),
                                ),
                              ),
                              const SizedBox(width: 20),
                              if (i + 1 < interestDto.length)
                                Expanded(
                                child: Interest(
                                    interestName: interestDto[i + 1]['interest_name'].toString(),
                                    iconCode: int.parse(interestDto[i + 1]['icon_code'].toString()),
                                    fontFamily: interestDto[i + 1]['font_family'].toString(),
                                ),
                              ) else Expanded(child: Container()),
                            ],
                          ),
                    ),
                  ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Center(
                    child: Row(
                      children: [
                        const SizedBox(height: 80),
                        prevBtn(context),
                        const Spacer(),
                        nextBtn(context)
                      ],
                    ),
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
          return RegistrationPictures(
            name: null,
            email: null,
            birthdate: birthdate,
            gender: gender,
            preference: preference,
            profilePicture: null,
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
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomeScreen(userService: Provider.of<UserService>(context));
        }));
      },
      child: const Text(
        "Create Profile",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
    );
  }
}
