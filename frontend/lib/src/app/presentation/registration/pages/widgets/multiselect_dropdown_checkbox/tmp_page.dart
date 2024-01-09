import 'package:flutter/material.dart';
import 'package:frontend/src/app/presentation/registration/pages/widgets/multiselect_dropdown_checkbox/multiselect_dropdown_checkbox.dart';

class TmpPage extends StatefulWidget {
  const TmpPage({super.key});

  @override
  State<TmpPage> createState() => _TmpPageState();
}

class _TmpPageState extends State<TmpPage> {
  List<String> _selectedItems = [];

  void _showMultiSelect() async {
    final List<String> items = [
      'man',
      'woman',
      'divers'
    ];

    final List<String>? results = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return MultiselectDropdownCheckbox(items: items);
        }
    );

    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
