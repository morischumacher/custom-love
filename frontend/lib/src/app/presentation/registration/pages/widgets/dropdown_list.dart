import 'package:flutter/material.dart';

import '../../../../../config/theme.dart';

class DropDownList extends StatefulWidget {
  const DropDownList({
    super.key,
    required this.labelText,
    required this.value,
    required this.options,
    required this.setParentValueFunction
  });

  final String labelText;
  final String? value;
  final List<String> options;
  final Function setParentValueFunction;

  @override
  State<DropDownList> createState() => _DropDownListState();
}

class _DropDownListState extends State<DropDownList> {
  @override
  void initState() {
    super.initState();
    labelText = widget.labelText;
    value = widget.value;
    options = widget.options;
    setParentValueFunction = widget.setParentValueFunction;
  }

  late String labelText;
  late String? value;
  late List<String> options;
  late Function setParentValueFunction;
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      value: value,
      items: options
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (val) {
        setState(() {
          value = val as String;
          setParentValueFunction(value);
        });
      },
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black,
      ),
      dropdownColor: _customLoveTheme.grayscale0,
      decoration: InputDecoration(
          labelText: labelText,
          fillColor: _customLoveTheme.grayscale0,
          filled: true,
          labelStyle: TextStyle(color: _customLoveTheme.grayscale1),
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: _customLoveTheme.formFieldBorder)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: _customLoveTheme.formFieldBorder)
          )
      ),
    );
  }
}

