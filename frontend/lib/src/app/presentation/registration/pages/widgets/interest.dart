import 'package:flutter/material.dart';

import '../../../../../config/theme.dart';
import '../../../swipe/util/interests.dart';

class Interest extends StatefulWidget {
  const Interest({
    super.key,
    required this.interestId,
    required this.interestName,
    required this.containsInterestFunction,
    required this.addRemoveInterestFunction
  });

  final int interestId;
  final String interestName;
  final Function containsInterestFunction;
  final Function addRemoveInterestFunction;

  @override
  State<Interest> createState() => _InterestState();
}

class _InterestState extends State<Interest> {
  @override
  void initState() {
    super.initState();
    interestId = widget.interestId;
    interestName = widget.interestName;
    containsInterestFunction = widget.containsInterestFunction;
    addRemoveInterestFunction = widget.addRemoveInterestFunction;
  }

  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  late int interestId;
  late String interestName;
  late Function containsInterestFunction;
  late Function addRemoveInterestFunction;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        icon: Icon(Interests.getIconData(interestName),
            color: containsInterestFunction(interestId) ? Colors.white : _customLoveTheme.tertiaryColor
        ),
        label: Text(interestName),
        onPressed: () {
          setState(() {
            addRemoveInterestFunction(interestId);
          });
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(20.0),
          backgroundColor: containsInterestFunction(interestId) ? _customLoveTheme.androidGreen : Colors.white,
          foregroundColor: containsInterestFunction(interestId) ? Colors.white : _customLoveTheme.tertiaryColor,
          elevation: 15,
          shadowColor: Colors.black,
          alignment: Alignment.center,
          shape: StadiumBorder(
              side: BorderSide(
                  width: 2,
                  color: containsInterestFunction(interestId) ? Colors.white : _customLoveTheme.tertiaryColor
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
