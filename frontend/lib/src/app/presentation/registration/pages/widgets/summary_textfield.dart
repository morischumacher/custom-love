import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../config/theme.dart';

class SummaryTextfield extends StatelessWidget {
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();
  final String label;
  final String input;

  const SummaryTextfield({
    super.key,
    required this.label,
    required this.input
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      label,
                      style: TextStyle(
                        color: _customLoveTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0
                      )
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: [
                      Text(
                          input,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              color: _customLoveTheme.textColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 20.0
                          )
                      )
                    ],
                  ),
                ],
              ),
            ),
            /* TODO: Add option to edit inputs once main components are done
            const SizedBox(width: 10),
            const Column(
              children: [
                Icon(Icons.edit),
              ],
            ),
             */
            // const SizedBox(height: 15.0)
          ],
        ),
        const SizedBox(height: 8)
      ],
    );
  }
}
