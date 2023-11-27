import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/profile_details_picture.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/widgets/page_title.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  _ProfileDetailsState() {
    _selectedGender = _genderList[0];
    _selectedPreference = _genderList[0];
  }

  final _genderList = ["Male", "Female", "Other"];
  String? _selectedGender = "";
  String? _selectedPreference = "";
  String? _selectedBirthdate = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.fromLTRB(21.0, 0, 21.0, 51.0),
            child: Center(
              child: Column(
                children: [
                  const PageTitle(
                      title: "Profile Details",
                      description: "Provide some basic data about yourself"
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
                    dropdownColor: Color(0xFFFFCCBC),
                    decoration: InputDecoration(
                        labelText: "Gender",
                        border: OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Color(0xFFE8E6EA)))),
                  ),
                  const SizedBox(height: 19.0),
                  DropdownButtonFormField(
                    value: _selectedPreference,
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
                    dropdownColor: Color(0xFFFFCCBC),
                    decoration: InputDecoration(
                        labelText: "Preference",
                        border: OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Color(0xFFE8E6EA)))),
                  ),
                  const SizedBox(height: 19.0),
                  TextField(
                    readOnly: true,
                    onTap: () {
                      selectDate();
                    },
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.calendar_today),
                        labelText: "Birthday",
                        border: OutlineInputBorder(),
                        enabledBorder: const OutlineInputBorder(
                            borderSide:
                            const BorderSide(color: Color(0xFFE8E6EA))
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
            )));
  }
  Future<void> selectDate() async {
    await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(DateTime.now().year)
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
          return ProfileDetailsPicture(
              gender: _selectedGender,
              preference: _selectedPreference,
              dob: _selectedBirthdate
          );
        }));
      },
      child: const Text(
        "Previous",
        style: const TextStyle(
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
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProfileDetailsPicture(
              gender: _selectedGender,
              preference: _selectedPreference,
              dob: _selectedBirthdate
          );
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
