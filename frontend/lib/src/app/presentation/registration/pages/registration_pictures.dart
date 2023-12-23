import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/footer/footer.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/theme.dart';
import '../../../service/gender_service.dart';
import '../../../service/interest_service.dart';
import '../enums/registration_page_enum.dart';

class RegistrationPictures extends StatefulWidget {
  const RegistrationPictures({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.gender,
    required this.preference,
    required this.birthdate,
    required this.profilePicture,
    required this.userInterestIdList,
    required this.location,
    required this.searchRadius
  }) : super(key: key);

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final Gender? gender;
  final Gender? preference;
  final String? birthdate;
  final Uint8List? profilePicture;
  final List<Interest> userInterestIdList;
  final Position? location;
  final double? searchRadius;

  @override
  State<RegistrationPictures> createState() => _RegistrationPicturesState();
}

class _RegistrationPicturesState extends State<RegistrationPictures> {
  @override
  void initState() {
    super.initState();
    firstName = widget.firstName;
    lastName = widget.lastName;
    email = widget.email;
    password = widget.password;
    gender = widget.gender;
    preference = widget.preference;
    birthdate = widget.birthdate;
    profilePicture = widget.profilePicture;
    userInterestIdList = widget.userInterestIdList;
    userLocation = widget.location;
    searchRadius = widget.searchRadius;
  }

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  late String? firstName;
  late String? lastName;
  late String? email;
  late String? password;
  late Gender? gender;
  late Gender? preference;
  late String? birthdate;
  Uint8List? profilePicture;
  late List<Interest> userInterestIdList;
  Position? userLocation;
  late double? searchRadius;

  // Web
  String defaultImageUrl = 'https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fblogs.timesofindia.indiatimes.com%2Fwp-content%2Fuploads%2F2016%2F11%2FNarendra-Modi-10-1.jpg&f=1&nofb=1&ipt=2934f6195ba86ab161d54c942491f87a1c68cc89b426d0601667d9052cf98010&ipo=images';
  String? selectFile = '';
  XFile? file;

  // Phone
  File ? _selectedPhoneImage;

  void _selectFile(bool imageFrom) async {
    FilePickerResult? fileResult = await FilePicker.platform.pickFiles();

    if (fileResult != null) {
      setState(() {
        selectFile = fileResult.files.first.name;
        profilePicture = fileResult.files.first.bytes;
      });

    }
  }

  Future _pickImageFromPhoneGallery() async {
    final returnedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;
    setState(() {
      _selectedPhoneImage = File(returnedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _customLoveTheme.neutralColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25.0, 0, 25, 0),
          child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: CustomScrollView(
                scrollBehavior:
                ScrollConfiguration.of(context).copyWith(scrollbars: false),
                slivers: [
                SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    const PageTitle(
                        title: "Profile Pictures",
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
                        // child: kIsWeb ? Image.memory(profilePicture!) : (_selectedPhoneImage != null ? Image.file(_selectedPhoneImage) : ""),
                        child: kIsWeb ? Image.memory(profilePicture!) : Image.file(_selectedPhoneImage!),
                      ),
                    const SizedBox(height: 19.0),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.075,
                      child: ElevatedButton.icon(
                          onPressed: () {
                            if (kIsWeb) {
                                _selectFile(true);
                            } else {
                              _pickImageFromPhoneGallery();
                            }
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
                    const SizedBox(height: 25.0),
                    Expanded(child: Container()),
                    Footer(
                        pageSection: RegistrationPageSection.pictures,
                        firstName: firstName,
                        lastName: lastName,
                        email: email,
                        password: password,
                        gender: gender,
                        genderPreference: preference,
                        birthdate: birthdate,
                        profilePicture: profilePicture,
                        userInterestIdList: userInterestIdList,
                        location: userLocation,
                        searchRadius: searchRadius
                    )
                  ],
                ),
                ),
                ],
              ),
          ),
        ),
      ));
  }
}
