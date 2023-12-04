import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/profile_details.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/profile_details_interests.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/profile_details_location.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/widgets/page_title.dart';
import 'package:image_picker/image_picker.dart';

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

  String defaultImageUrl = 'https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fblogs.timesofindia.indiatimes.com%2Fwp-content%2Fuploads%2F2016%2F11%2FNarendra-Modi-10-1.jpg&f=1&nofb=1&ipt=2934f6195ba86ab161d54c942491f87a1c68cc89b426d0601667d9052cf98010&ipo=images';
  String? selectFile = '';
  XFile? file;
  Uint8List? selectedImageInBytes;

  _selectFile(bool imageFrom) async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();

    if (fileResult != null) {
      setState(() {
        selectFile = fileResult.files.first.name;
        selectedImageInBytes = fileResult.files.first.bytes;
      });

    }
    print(selectFile);
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
                      description: "Provide up to five pictures of yourself",
                      bottomPadding: 70.0,
                  ),
                  const SizedBox(height: 19.0),
                  if (!selectFile!.isEmpty)
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Image.memory(selectedImageInBytes!),
                    ),
                  const SizedBox(height: 19.0),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: ElevatedButton.icon(
                        onPressed: () {
                          _selectFile(true);
                        },
                        icon: const Icon(Icons.camera),
                        label: const Text(
                          'Choose Image',
                          style: TextStyle(),
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
