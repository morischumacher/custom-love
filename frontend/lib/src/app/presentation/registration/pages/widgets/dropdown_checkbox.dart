import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

import '../../../../../config/theme.dart';

class DropdownCheckbox extends StatefulWidget {

  const DropdownCheckbox({
    super.key
  });

  @override
  State<DropdownCheckbox> createState() => _DropdownCheckboxState();
}

class _DropdownCheckboxState extends State<DropdownCheckbox> {
  var controller = MultiSelectController();
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          children: [
            MultiSelectDropDown(
              padding: const EdgeInsets.all(0),
              hint: "Preference",
              hintStyle: TextStyle(
                color: _customLoveTheme.grayscale1,
                fontSize: 16,
                fontFamily: GoogleFonts.roboto().fontFamily
              ),
              fieldBackgroundColor: _customLoveTheme.grayscale0,
              borderRadius: 5.0,
              showClearIcon: true,
              controller: controller,
              onOptionSelected: (options) {
                debugPrint(options.toString());
              },
              options: const <ValueItem>[
                ValueItem(label: 'Option 1', value: '1'),
                ValueItem(label: 'Option 2', value: '2'),
                ValueItem(label: 'Option 3', value: '3'),
                ValueItem(label: 'Option 4', value: '4'),
                ValueItem(label: 'Option 5', value: '5'),
                ValueItem(label: 'Option 6', value: '6'),
              ],
              disabledOptions: const [ValueItem(label: 'Option 1', value: '1')],
              selectionType: SelectionType.multi,
              chipConfig: const ChipConfig(wrapType: WrapType.wrap),
              dropdownHeight: 250,
              optionTextStyle: const TextStyle(fontSize: 16),
              optionsBackgroundColor: _customLoveTheme.grayscale1,
              selectedOptionIcon: const Icon(Icons.check_circle),
              borderColor: _customLoveTheme.formFieldBorder,
            ),
          ],
        ),
    );
  }
}
