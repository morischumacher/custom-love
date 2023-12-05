import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/authentification/pages/login_page.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/profile_details_picture.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/widgets/page_title.dart';
import 'package:provider/provider.dart';

import '../../../../config/theme.dart';
import '../../../service/login_service.dart';
import '../../../service/user_service.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  _ProfileDetailsState() {
    _selectedGender = null;
    _selectedPreference = null;
  }

  final TextEditingController _dateController = TextEditingController();
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final _genderList = ["Male", "Female", "Other"];
  String? _selectedGender = "";
  String? _selectedPreference = "";
  String? _selectedBirthdate = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _customLoveTheme.neutralColor,
        body: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 500),
              padding: EdgeInsets.fromLTRB(21.0, 0, 21.0, 51.0),
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
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          labelText: "Gender",
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
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
                      value: null,
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
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
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
                          suffixIcon: Icon(Icons.calendar_today),
                          labelText: "Birthday",
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
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
          return LoginPage(
              loginService: Provider.of<LoginService>(context),
              userService: Provider.of<UserService>(context),
          );
        }));
      },
      child: const Text(
        "Return",
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
          backgroundColor: _customLoveTheme.primaryColor,
          side: BorderSide.none
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
