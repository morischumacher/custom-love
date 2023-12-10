import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/registration/controller/registration_controller.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_pictures.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/interest.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';

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

  final RegistrationController _controller = RegistrationController();
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  late String? name;
  late String? email;
  late String? gender;
  late String? preference;
  late String? birthdate;
  late Uint8List? profilePicture;
  late Set<int> userInterestIdList;

  final interestDto = [
    {"id": 1, "name": "sports"},
    {"id": 2, "name": "movies"},
    {"id": 3, "name": "travel"},
    {"id": 4, "name": "science"},
    {"id": 5, "name": "books"},
    {"id": 6, "name": "music"},
    {"id": 7, "name": "art"},
    {"id": 8, "name": "food"},
    {"id": 9, "name": "technology"},
    {"id": 10, "name": "fashion"},
    {"id": 11, "name": "photography"},
    {"id": 12, "name": "gaming"},
    {"id": 13, "name": "nature"},
    {"id": 14, "name": "history"},
    {"id": 15, "name": "fitness"},
    {"id": 16, "name": "crafts"},
    {"id": 17, "name": "writing"},
    {"id": 18, "name": "gardening"},
    {"id": 19, "name": "philosophy"},
    {"id": 20, "name": "coding"}
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
                                    interestName: interestDto[i]['name'].toString(),
                                    containsInterestFunction: containsInterest,
                                    addRemoveInterestFunction: addRemoveInterest
                                ),
                              ),
                              const SizedBox(width: 20),
                              if (i + 1 < interestDto.length)
                                Expanded(
                                child: Interest(
                                  interestId: interestDto[i + 1]['id'] as int,
                                  interestName: interestDto[i + 1]['name'].toString(),
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
        Future<void>.value(
            _controller.handleRegistration(
                context,
              name,
              "TEST",
              email,
              "TEST1",
              "TEST BIO",
              gender,
              preference,
              birthdate,
              "TEST JOB",
              null,
              userInterestIdList,
              1
            )
        );
        /*
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HomeScreen(userService: Provider.of<UserService>(context));
        }));
         */
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
