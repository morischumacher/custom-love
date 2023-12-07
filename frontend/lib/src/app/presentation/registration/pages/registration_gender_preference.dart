import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_name_email.dart';
import 'package:frontend/src/app/presentation/registration/pages/registration_pictures.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/page_title.dart';

import '../../../../config/theme.dart';

class RegistrationGenderPreference extends StatefulWidget {
  const RegistrationGenderPreference({
    super.key,
    required this.name,
    required this.email,
    required this.gender,
    required this.preference,
    required this.birthdate,
    required this.profilePicture,
    required this.userInterestIdList
  });

  final String? name;
  final String? email;
  final String? gender;
  final String? preference;
  final String? birthdate;
  final Uint8List? profilePicture;
  final Set<int> userInterestIdList;

  @override
  State<RegistrationGenderPreference> createState() => _RegistrationGenderPreferenceState();
}

class _RegistrationGenderPreferenceState extends State<RegistrationGenderPreference> {
  @override
  void initState() {
    super.initState();
    name = widget.name;
    email = widget.email;
    _selectedGender = widget.gender;
    _selectedPreference = widget.preference;
    _dateController.value = TextEditingValue(text: widget.birthdate == null ? "" : widget.birthdate as String);
    profilePicture = widget.profilePicture;
    userInterestIdList = widget.userInterestIdList;
  }

  late String? name;
  late String? email;
  String? _selectedGender = "";
  String? _selectedPreference = "";
  late Uint8List? profilePicture;
  late Set<int> userInterestIdList;

  final TextEditingController _dateController = TextEditingController();
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final _genderList = ["Male", "Female", "Other"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _customLoveTheme.neutralColor,
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.fromLTRB(21.0, 0, 21.0, 51.0),
              child: Center(
                child: Column(
                  children: [
                    const PageTitle(
                        title: "Profile Details",
                        description: "Provide some basic data about yourself",
                        bottomPadding: 70.0,
                    ),
                    DropdownButtonFormField(
                      value: _selectedGender,
                      items: _genderList
                          .map((e) => DropdownMenuItem(child: Text(e), value: e))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedGender = val as String;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      dropdownColor: Colors.grey.shade200,
                      decoration: InputDecoration(
                          labelText: "Gender",
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          labelStyle: TextStyle(color: Colors.grey[500]),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: _customLoveTheme.formFieldBorder)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: _customLoveTheme.formFieldBorder)
                          )
                      ),
                    ),
                    const SizedBox(height: 19.0),
                    DropdownButtonFormField(
                      value: _selectedPreference,
                      items: _genderList
                          .map((e) => DropdownMenuItem(child: Text(e), value: e))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedPreference = val as String;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black,
                      ),
                      dropdownColor: Colors.grey.shade200,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          labelText: "Preference",
                          labelStyle: TextStyle(color: Colors.grey[500]),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: _customLoveTheme.formFieldBorder)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: _customLoveTheme.formFieldBorder)
                          )
                      ),
                    ),
                    const SizedBox(height: 19.0),
                    TextField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: () {
                        selectDate();
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          suffixIcon: const Icon(Icons.calendar_today),
                          labelText: "Birthday",
                          labelStyle: TextStyle(color: Colors.grey[500]),
                          border: const OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: _customLoveTheme.formFieldBorder)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: _customLoveTheme.formFieldBorder)
                          )
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
              )),
        ));
  }

  Future<void> selectDate() async {
    final today = DateTime.now();
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime(today.year - 18, today.month, today.day),
        firstDate: DateTime(1900),
        lastDate: DateTime(today.year - 18, today.month, today.day)
    );

    if (_picked != null) {
      _dateController.text = _picked.toString().split(" ")[0];
    }
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
          return RegistrationNameEmail(
            name: name,
            email: email,
            gender: _selectedGender,
            preference: _selectedPreference,
            birthdate: _dateController.value.text,
            profilePicture: profilePicture,
            userInterestIdList: userInterestIdList
          );
        }));
      },
      child: const Text(
        "Return",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
    );
  }

  OutlinedButton nextBtn(BuildContext context) {
    const CustomLoveTheme _customLoveTheme = CustomLoveTheme();

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          minimumSize: const Size(156, 56),
          backgroundColor: _customLoveTheme.primaryColor,
          side: BorderSide.none
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return RegistrationPictures(
              name: name,
              email: email,
              gender: _selectedGender,
              preference: _selectedPreference,
              birthdate: _dateController.value.text,
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
