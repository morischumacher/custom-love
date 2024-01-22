import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/gender_model.dart';
import 'package:frontend/src/app/model/interest_model.dart';
import 'package:frontend/src/app/model/language_model.dart';
import 'package:frontend/src/app/model/user_detailed.dart';
import 'package:frontend/src/app/presentation/authentification/components/sign_in_button.dart';
import 'package:frontend/src/app/presentation/profile/controller/profile_controller.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/dropdown_checkboxes/dropdown_checkbox.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/dropdown_checkboxes/interest_dropdown_checkbox.dart';
import 'package:frontend/src/app/service/user_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../../../config/app_state.dart';
import '../../../../config/theme.dart';
import '../../../service/image_service.dart';
import '../../authentification/controller/login_controller.dart';
import '../../registration/controller/registration_controller.dart';
import '../../registration/pages/widgets/bio_textfield.dart';
import '../../registration/pages/widgets/dropdown_checkboxes/language_dropdown_checkbox.dart';
import '../../registration/pages/widgets/summary_textfield.dart';
import '../../registration/pages/widgets/textfield.dart';
import '../../utils/secure_storage_service.dart';

class Profile extends StatefulWidget {
  final UserService userService;

  const Profile({Key? key, required this.userService}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    getUsers();
  }

  ImageService? _service;
  ProfileImageStorage? _storage;
  final LoginController _logoutController = LoginController();
  final ProfileController _profileController = ProfileController();

  Future<void> getProfilePicture() async {
    if (user != null) {
      if (_service == null ||
          _storage == null ||
          _storage!.loaded(user!.profilePictureId)) {
        return;
      }

      var tmp = await _service!.getImage("profile-picture/${user!.id}");
      _storage!.load(user!.profilePictureId, tmp);
    }
  }

  void getUsers() async {
    await _secureStorageService.retrieveUserId().then((id) {
      widget.userService.getUserProfile(int.parse(id!)).then((value) {
        setState(() {
          user = value['user'];
          genderDto = value['genders'];
          for (Gender gender in genderDto) {
            genderPreferences.options.add(
                ValueItem(label: gender.name, value: gender)
            );
          }
          for (Gender preference in user!.genderPreferences) {
            genderPreferences.addSelectedOption(
                ValueItem<Gender>(label: preference.name, value: preference)
            );
          }

          interestDto = value['interests'];
          for (Interest interest in interestDto) {
            interests.options.add(
                ValueItem(label: interest.name, value: interest)
            );
          }
          for (Interest interest in user!.interests) {
            interests.addSelectedOption(
                ValueItem<Interest>(label: interest.name, value: interest)
            );
          }

          languageDto = value['languages'];
          for (Language language in languageDto) {
            languages.options.add(
                ValueItem(label: language.name, value: language)
            );
          }
          for (Language language in user!.languages) {
            languages.addSelectedOption(
                ValueItem<Language>(label: language.name, value: language)
            );
          }
          bio = user!.bio;
          job = user!.job;
          searchRadius = user!.searchRadius < 5 ? 5 : (user!.searchRadius > 100 ? 100 : user!.searchRadius);
        });
      });
    });
  }

  final SecureStorageService _secureStorageService = SecureStorageService();
  final RegistrationController _controller = RegistrationController();
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  UserDetailed? user;

  // Property values
  List<Gender> genderDto = [];
  List<Interest> interestDto = [];
  List<Language> languageDto = [];

  // Editable attributes
  bool editMode = false;
  bool warning = false;
  MultiSelectController<Gender> genderPreferences = MultiSelectController<Gender>();
  int searchRadius = 5;
  MultiSelectController<Interest> interests = MultiSelectController<Interest>();
  String bio = "";
  String job = "";
  MultiSelectController<Language> languages = MultiSelectController<Language>();

  XFile? profileImageNewXFile;
  Uint8List? profileImageNewUint;

  Future<Uint8List?> galleryImagePicker(ImageSource imageSource) async {
    ImagePicker picker = ImagePicker();

    XFile? file = await picker.pickImage(
      source: imageSource,
      imageQuality: 90,
    );
    profileImageNewXFile = file;

    if (file != null) return await file.readAsBytes(); // convert into Uint8List.
    return null;
  }

  @override
  Widget build(BuildContext context) {
    _service = Provider.of<ImageService>(context);
    _storage = Provider.of<ProfileImageStorage>(context);
    getProfilePicture();

    Consumer<ProfileImageStorage> img = Consumer<ProfileImageStorage>(
      builder:
          (BuildContext context, ProfileImageStorage storage, Widget? child) {
        int id = user!.profilePictureId;

        if (!storage.loaded(id)) {
          return const Icon(Icons.downloading);
        }

        return Stack(
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(width: 4, color: _customLoveTheme.whiteColor),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.1)
                  )
                ],
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.memory(
                    profileImageNewUint == null ? storage.getBytes(id)! : profileImageNewUint!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ).image
                )
              ),
            ),
            Positioned(
                bottom: 10,
                right: 10,
                child: ElevatedButton(
                  onPressed: ()  async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Upload image'),
                            content: const SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text("Choose the upload source"),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  final Uint8List? image = await galleryImagePicker(ImageSource.gallery);

                                  if (image != null) {
                                    _service?.putImage(profileImageNewXFile!, 'profile-picture');
                                    _storage!.load(user!.profilePictureId, image);
                                    setState(() {
                                      profileImageNewUint = image;
                                    });
                                  }
                                },
                                child: Text(
                                  "From Gallery"
                                )
                              ),
                              TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    final Uint8List? image = await galleryImagePicker(ImageSource.camera);

                                    if (image != null) {
                                      _service?.putImage(profileImageNewXFile!, 'profile-picture');
                                      _storage!.load(user!.profilePictureId, image);
                                      setState(() {
                                        profileImageNewUint = image;
                                      });
                                    }
                                  },
                                  child: Text(
                                      "From Camera"
                                  )
                              ),
                            ]);
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: _customLoveTheme.primaryColor,
                    minimumSize: const Size(40, 40)
                  ),
                  child: Icon(
                    Icons.edit,
                    color: _customLoveTheme.whiteColor,
                  ),
                )
            )
          ],
        );
      },
    );

    return Scaffold(
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
                    children: <Widget>[
                      Expanded(child: Container()),
                      if (user == null)
                        SizedBox(
                            height: 100,
                            width: 100,
                            child: CircularProgressIndicator(
                                color: _customLoveTheme.primaryColor,
                                strokeWidth: 18
                            )
                        ),
                      if (user != null)
                        img,

                      if (user != null && !editMode)
                      // registration_name_email
                        Column(children: [
                          SummaryTextfield(label: "First name", input: user!.firstName),
                          SummaryTextfield(label: "Last name", input: user!.lastName),
                          SummaryTextfield(label: "Email", input: user!.email),

                          // registration_gender_preference
                          SummaryTextfield(label: "Gender Identity", input: user!.genderIdentity.name),
                          SummaryTextfield(label: "Gender Preference", input: _controller.genderListToString(user!.genderPreferences)),
                          SummaryTextfield(label: "Birthdate", input: user!.dateOfBirth.substring(0, 10)),

                          // registration_radius
                          SummaryTextfield(label: "Search Radius", input: "${user!.searchRadius} km / ${(user!.searchRadius * 0.621371).roundToDouble()} mi"),

                          SummaryTextfield(label: "Interests", input: _controller.interestsListToString(user!.interests)),
                          SummaryTextfield(label: "Languages", input: _controller.languageListToString(user!.languages)),

                          // registration_job_bio
                          SummaryTextfield(label: "Job", input: user!.job),
                          SummaryTextfield(label: "Bio", input: user!.bio),
                          SummaryTextfield(label: "Swipes left", input: user!.swipesLeft.toString()),

                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                editMode = true;
                              });
                            },
                            child: const Text('Edit'),
                          ),
                        ]),
                      if (user != null && editMode)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: _customLoveTheme.neutralColor
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(children: [
                              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text(
                                    "${user!.firstName} ${user!.lastName}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 36,
                                        color: _customLoveTheme.textColor
                                    ),
                                  ),
                                  Text(
                                    user!.email,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: _customLoveTheme.textColor
                                    ),
                                  ),
                                  Text(
                                    "Born: ${user!.dateOfBirth.substring(0, 10)}, Identifies as: ${user!.genderIdentity.name}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: _customLoveTheme.textColor
                                    ),
                                  ),
                                ],),
                                Spacer(),
                                Text("11 swipes left")
                              ],
                              ),
                              const SizedBox(height: 25.0),
                              Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Search radius: $searchRadius km, ${(searchRadius * 0.621371).roundToDouble()} mi",
                                      textAlign: TextAlign.left
                                  ),
                                  Slider(
                                      min: 5,
                                      max: 100,
                                      divisions: 99,
                                      label: searchRadius.toString(),
                                      value: searchRadius.toDouble(),
                                      activeColor: _customLoveTheme.primaryColor,
                                      onChanged: (value) {
                                        setState(() {
                                          searchRadius = value.toInt();
                                        });
                                      }),
                                ],
                              ),
                              RegistrationBioTextfield(
                                    controller: bio,
                                    hintText: "Bio",
                                    characterLimit: 256,
                                    callback: (val) => setState(() => bio = val)
                              ),
                              const SizedBox(height: 25.0),
                              RegistrationTextfield(
                                  controller: job,
                                  hintText: "Job",
                                  obscureText: false,
                                  callback: (val) => setState(() => job = val)
                              ),
                              const SizedBox(height: 19.0),
                              DropdownCheckbox(
                                  pickedGenderPreferences: genderPreferences,
                                  callback: (val) => setState(() {})
                              ),
                              const SizedBox(height: 19.0),
                              LanguageDropdownCheckbox(
                                  pickedLanguages: languages,
                                  callback: (val) => setState(() {})
                              ),
                              const SizedBox(height: 19.0),
                              InterestDropdownCheckbox(
                                  pickedInterests: interests,
                                  callback: (val) => setState(() {})
                              ),
                              if (interests.selectedOptions.length < 3 || interests.selectedOptions.length > 5)
                                Text(
                                  "You need to have 3 - 5 interests",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: _customLoveTheme.redColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              const SizedBox(height: 19.0),
                              ElevatedButton(
                                onPressed: () async {
                                  if (interests.selectedOptions.length >= 3 && interests.selectedOptions.length <= 5) {
                                    UserDetailed? result = await _profileController.updateUser(
                                        context,
                                        job,
                                        bio,
                                        listValuesToGenderList(genderPreferences.selectedOptions),
                                        listValuesToInterestList(interests.selectedOptions),
                                        listValuesToLanguageList(languages.selectedOptions),
                                        searchRadius
                                    );
                                    setState(() {
                                      user = result;
                                      editMode = false;
                                    });
                                  }
                                },
                                child: const Text('Confirm changes'),
                              ),
                              const SizedBox(height: 19.0),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    editMode = false;
                                  });
                                },
                                child: const Text('Discard changes'),
                              ),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                      Expanded(child: Container()),
                      LoginButton(
                          onTap: () {
                            Future<void>.value(_logoutController.handleLogout(context));
                          },
                          color: _customLoveTheme.primaryColor,
                          text: "Logout"
                      ),
                      const SizedBox(height: 30.0)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<int> listValuesToLanguageList(List<ValueItem<Language>> valueItems) {
    List<int> extractedLanguages = [];
    for (ValueItem<Language> item in valueItems) {
      if (item.value != null) {
        extractedLanguages.add(item.value!.id);
      }
    }
    return extractedLanguages;
  }

  List<int> listValuesToGenderList(List<ValueItem<Gender>> valueItems) {
    List<int> extractedGenders = [];
    for (ValueItem<Gender> item in valueItems) {
      if (item.value != null) {
        extractedGenders.add(item.value!.id);
      }
    }
    return extractedGenders;
  }

  List<int> listValuesToInterestList(List<ValueItem<Interest>> valueItems) {
    List<int> extractedInterests = [];
    for (ValueItem<Interest> item in valueItems) {
      if (item.value != null) {
        extractedInterests.add(item.value!.id);
      }
    }
    return extractedInterests;
  }
}
