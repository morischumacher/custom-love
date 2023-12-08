import 'package:flutter/material.dart';

import '../../../../../config/theme.dart';

class BirthdateField extends StatelessWidget {
  final TextEditingController? controller;
  final BuildContext context;
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  const BirthdateField({
    super.key,
    required this.controller,
    required this.context
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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
    );
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
      controller?.text = _picked.toString().split(" ")[0];
    }
  }
}
