import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/profile_details_interests.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/profile_details_picture.dart';
import 'package:frontend/src/app/presentation/profile_details/pages/widgets/page_title.dart';

/*
class ProfileDetailsLocation extends StatefulWidget {
  const ProfileDetailsLocation({super.key});

  @override
  State<ProfileDetailsLocation> createState() => _ProfileDetailsLocationState();
}

class _ProfileDetailsLocationState extends State<ProfileDetailsLocation> {
  _ProfileDetailsLocationState() {
    _selectedCountry = _countryList[0];
    _selectedCity = _cityList[0];
    _selectedDistrict = _districtList[0];
  }
  final _countryList = ["Austria", "Germany", "France"];
  final _cityList = ["Vienna", "Graz", "Innsbruck", "Salzburg"];
  final _districtList = ["1", "2", "3"];
  String? _selectedCountry = "";
  String? _selectedCity = "";
  String? _selectedDistrict = "";

  double _radiusValue = 40;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.fromLTRB(21.0, 0, 21.0, 51.0),
          child: Center(
            child: Column(
              children: [
                const PageTitle(
                    title: "Location",
                    description: "Provide information about your location",
                    bottomPadding: 150.0,
                ),
                DropdownButtonFormField(
                  value: _selectedCountry,
                  items: _countryList
                      .map((e) => DropdownMenuItem(child: Text(e), value: e))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedCountry = val as String;
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                  dropdownColor: Color(0xFFFFCCBC),
                  decoration: InputDecoration(
                      labelText: "Country",
                      border: OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Color(0xFFE8E6EA)))),
                ),
                const SizedBox(height: 19.0),
                DropdownButtonFormField(
                  value: _selectedCity,
                  items: _cityList
                      .map((e) => DropdownMenuItem(child: Text(e), value: e))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedCity = val as String;
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                  dropdownColor: Color(0xFFFFCCBC),
                  decoration: InputDecoration(
                      labelText: "City",
                      border: OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(
                          borderSide:
                          const BorderSide(color: Color(0xFFE8E6EA)))),
                ),

                const SizedBox(height: 19.0),

                Slider(
                  activeColor: const Color(0xFF953829),
                    min: 0,
                    max: 80,
                    divisions: 80,
                    value: _radiusValue,
                    label: _radiusValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _radiusValue = value;
                      });
                    }
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
    );

  }

  OutlinedButton prevBtn(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFF953829),
          minimumSize: const Size(156, 56)
      ),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ProfileDetailsPicture(
              gender: null,
              preference: null,
              dob: null
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
          backgroundColor: const Color(0xFF953829)
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


 */
