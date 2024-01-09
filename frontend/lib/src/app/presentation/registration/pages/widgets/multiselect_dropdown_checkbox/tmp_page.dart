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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiselect'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(onPressed: _showMultiSelect, child: const Text('Select genders')),
            const Divider(height: 30),
            Wrap(children: _selectedItems.map((e) => Chip(label: Text(e), shadowColor: Colors.red,)).toList())
          ],
        ),
      ),
    );
  }
}
