import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const List<String> list = <String>['Male', 'Female', 'Other'];

class ProfileDetails extends StatefulWidget {
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: Scaffold(
            body: SafeArea(
                child: Center(
                  child: Column(
                      children: [
                        Padding(
                          padding:EdgeInsets.fromLTRB(0, 103, 0, 0),
                          child: SizedBox(
                              child: Text(
                                  "Profile Details",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 34.0
                                  )
                              )
                          ),
                        ),
                        Padding(
                          padding:EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child:                     SizedBox(
                              child: Text(
                                  "Provide some basic data about yourself",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xFF797C7B) // Colors.white70
                                  )
                              )
                          ),
                        ),
                        DropdownMenuExample(),
                        DropdownMenuExample()
                      ]
                  ),
                )
            )

        )
    );
  }
}

class DropdownMenuExample extends StatefulWidget {
  const DropdownMenuExample({super.key});

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      initialSelection: list.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );
  }
}
