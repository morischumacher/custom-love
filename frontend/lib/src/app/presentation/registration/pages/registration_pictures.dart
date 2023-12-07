import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_gender_preference.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_interests.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/theme.dart';

class RegistrationPictures extends StatefulWidget {
  const RegistrationPictures({
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
  State<RegistrationPictures> createState() => _RegistrationPicturesState();
}

class _RegistrationPicturesState extends State<RegistrationPictures> {
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
  Uint8List? profilePicture;
  late Set<int> userInterestIdList;

  String defaultImageUrl = 'https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fblogs.timesofindia.indiatimes.com%2Fwp-content%2Fuploads%2F2016%2F11%2FNarendra-Modi-10-1.jpg&f=1&nofb=1&ipt=2934f6195ba86ab161d54c942491f87a1c68cc89b426d0601667d9052cf98010&ipo=images';
  String? selectFile = '';
  XFile? file;

  _selectFile(bool imageFrom) async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();

    if (fileResult != null) {
      setState(() {
        selectFile = fileResult.files.first.name;
        profilePicture = fileResult.files.first.bytes;
      });

    }
  }

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
                      // description: "Provide up to five pictures of yourself",
                      description: "Provide a profile picture of yourself",
                      bottomPadding: 70.0,
                  ),
                  const SizedBox(height: 19.0),
                  if (profilePicture != null && profilePicture!.isNotEmpty)
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 5,
                            color: _customLoveTheme.primaryColor
                        )
                      ),
                      child: Image.memory(profilePicture!),
                    ),
                  const SizedBox(height: 19.0),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.075,
                    child: ElevatedButton.icon(
                        onPressed: () {
                          _selectFile(true);
                        },
                        icon: Icon(Icons.camera, color: _customLoveTheme.primaryColor,),
                        label: Text(
                          'Choose Image',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _customLoveTheme.primaryColor
                          ),
                        ))
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
          return RegistrationGenderPreference(
            name: name,
            email: email,
            gender: gender,
            preference: preference,
            birthdate: birthdate,
            profilePicture: profilePicture,
            userInterestIdList: userInterestIdList
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
          return RegistrationInterests(
            name: name,
            email: email,
            birthdate: birthdate,
            gender: gender,
            preference: preference,
            profilePicture: profilePicture,
            userInterestIdList: userInterestIdList,
          );
        }));
      },
      child: const Text(
        "Next",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
    );
  }
}
