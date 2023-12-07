import 'dart:typed_data';

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
    required this.name,
    required this.email,
    required this.gender,
    required this.preference,
    required this.birthdate,
    required this.profilePicture,
    required this.userInterestIdList
  }) : super(key: key);

  final String? name;
  final String? email;
  final String? gender;
  final String? preference;
  final String? birthdate;
  final Uint8List? profilePicture;
  final Set<int> userInterestIdList;

  @override
  State<RegistrationInterests> createState() => _RegistrationInterestsState();
}

class _RegistrationInterestsState extends State<RegistrationInterests> {
  @override
  void initState() {
    super.initState();
    name = widget.name;
    email = widget.email;
    gender = widget.gender;
    preference = widget.preference;
    birthdate = widget.birthdate;
    profilePicture = widget.profilePicture;
    userInterestIdList = widget.userInterestIdList;
  }

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  late String? name;
  late String? email;
  late String? gender;
  late String? preference;
  late String? birthdate;
  late Uint8List? profilePicture;
  late Set<int> userInterestIdList;

  final interestDto = [
    {'id': 1, 'icon_code': 0xe4b6, 'font_family': 'MaterialIcons', 'interest_name': 'Photography'},
    {'id': 2, 'icon_code': 0xe59a, 'font_family': 'MaterialIcons', 'interest_name': 'Shopping'},
    {'id': 3, 'icon_code': 0xf8bd, 'font_family': 'MaterialIcons', 'interest_name': 'Karaoke'},
    {'id': 4, 'icon_code': 0xe5f3, 'font_family': 'MaterialIcons', 'interest_name': 'Tennis'},
    {'id': 5, 'icon_code': 0xe39b, 'font_family': 'MaterialIcons', 'interest_name': 'Movies'},
    {'id': 6, 'icon_code': 0xe5e3, 'font_family': 'MaterialIcons', 'interest_name': 'Sports'},
    {'id': 7, 'icon_code': 0xe5e4, 'font_family': 'MaterialIcons', 'interest_name': 'Bars'},
    {'id': 8, 'icon_code': 0xf02ee, 'font_family': 'MaterialIcons', 'interest_name': 'Travel'}, // 0xf02ee
    {'id': 9, 'icon_code': 0xe0ef, 'font_family': 'MaterialIcons', 'interest_name': 'Book'},
    {'id': 10, 'icon_code': 0xe55a, 'font_family': 'MaterialIcons', 'interest_name': 'Science'},
    {'id': 11, 'icon_code': 0xf06c3, 'font_family': 'MaterialIcons', 'interest_name': 'Yoga'},
    {'id': 12, 'icon_code': 0xe28e, 'font_family': 'MaterialIcons', 'interest_name': 'LGBTQ rights'},
    {'id': 13, 'icon_code': 0xe67c, 'font_family': 'MaterialIcons', 'interest_name': 'Road trips'},
    {'id': 14, 'icon_code': 0xf32c, 'font_family': 'MaterialIcons', 'interest_name': 'Jogging'},
    {'id': 15, 'icon_code': 0xe1d3, 'font_family': 'MaterialIcons', 'interest_name': 'Jetski'},
    {'id': 16, 'icon_code': 0xe2f2, 'font_family': 'MaterialIcons', 'interest_name': 'Social Justice'},
    {'id': 17, 'icon_code': 0xe4c1, 'font_family': 'MaterialIcons', 'interest_name': 'NFTs'},
    {'id': 18, 'icon_code': 0xeede, 'font_family': 'MaterialIcons', 'interest_name': 'Marvel'},
    {'id': 19, 'icon_code': 0xf03dd, 'font_family': 'MaterialIcons', 'interest_name': 'Gym'},
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
                                    interestId: interestDto[i]['id'] as int,
                                    interestName: interestDto[i]['interest_name'].toString(),
                                    iconCode: int.parse(interestDto[i]['icon_code'].toString()),
                                    fontFamily: interestDto[i]['font_family'].toString(),
                                    containsInterestFunction: containsInterest,
                                    addRemoveInterestFunction: addRemoveInterest
                                ),
                              ),
                              const SizedBox(width: 20),
                              if (i + 1 < interestDto.length)
                                Expanded(
                                child: Interest(
                                  interestId: interestDto[i + 1]['id'] as int,
                                  interestName: interestDto[i + 1]['interest_name'].toString(),
                                  iconCode: int.parse(interestDto[i + 1]['icon_code'].toString()),
                                  fontFamily: interestDto[i + 1]['font_family'].toString(),
                                  containsInterestFunction: containsInterest,
                                    addRemoveInterestFunction: addRemoveInterest
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
            userInterestIdList: userInterestIdList,
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

  bool containsInterest(int id) {
    return userInterestIdList.contains(id);
  }

  void addRemoveInterest(int id) {
    containsInterest(id) ?
    userInterestIdList.removeWhere((interestId) => interestId == id) :
    userInterestIdList.add(id);
  }
}
