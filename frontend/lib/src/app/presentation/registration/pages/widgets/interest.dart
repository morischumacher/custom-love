import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../config/theme.dart';

class Interest extends StatefulWidget {
  const Interest({
    super.key,
    required this.interestName,
    required this.iconCode,
    required this.fontFamily
  });

  final String interestName;
  final int iconCode;
  final String fontFamily;

  @override
  State<Interest> createState() => _InterestState();
}

class _InterestState extends State<Interest> {
  @override
  void initState() {
    super.initState();
    interestName = widget.interestName;
    iconCode = widget.iconCode;
    fontFamily = widget.fontFamily;
  }

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  late int iconCode;
  late String fontFamily;
  late String interestName;
  bool interestSelected = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      // child: const Text("Shopping"),
        icon: Icon(IconData(iconCode, fontFamily: fontFamily), color: interestSelected == true ? Colors.white : _customLoveTheme.tertiaryColor),
        label: Text(interestName),
        onPressed: () {
          setState(() {
            interestSelected = !interestSelected;
          });
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20.0),
          backgroundColor: interestSelected == true ? _customLoveTheme.selected : Colors.white,
          foregroundColor: interestSelected == true ? Colors.white : _customLoveTheme.tertiaryColor,
          elevation: 15,
          shadowColor: Colors.black,
          alignment: Alignment.center,
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          shape: StadiumBorder(
              side: BorderSide(
                  width: 2,
                  color: interestSelected == true ? Colors.white : _customLoveTheme.tertiaryColor
              )
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        )
    );
  }
}
