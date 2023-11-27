import 'package:flutter/material.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({super.key});

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  _ProfileDetailsState() {
    _selectedVal = _productSizesList[0];
    _selectedGender = _genderList[0];
    _selectedPreference = _genderList[0];
  }

  final _productSizesList = ["Small", "Medium", "Large", "Xlarge"];
  String? _selectedVal = "";

  final _genderList = ["Male", "Female", "Other"];
  String? _selectedGender = "";
  String? _selectedPreference = "";
  String? _selectedBirthdate = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.fromLTRB(21.0, 0, 21.0, 0),
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 51.0),
                  SizedBox(
                      child: Text("Profile Details",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 34.0,
                              color: Colors.black,
                              decoration: TextDecoration.none))),
                  SizedBox(
                      child: Text("Provide some basic data about yourself",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Color(0xFF797C7B), // Colors.white70
                            decoration: TextDecoration.none,
                            fontStyle: FontStyle.italic,
                          ))),
                  const SizedBox(height: 150.0),
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
}
