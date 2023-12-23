import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/src/config/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'menu_item.dart';

class PopupMenu extends StatelessWidget {
  final CustomLoveTheme _theme = const CustomLoveTheme();

  const PopupMenu({super.key});

  Future getImage(ImageSource media, ImagePicker picker) async {
    var img = await picker.pickImage(source: media);
  }

  void myAlert(BuildContext context, ImagePicker picker) {
    List<Widget> buttons = [
      MenuItem(
        label: "From Gallery",
        icon: Icons.image,
        onTap: () {
          Navigator.pop(context);
          getImage(ImageSource.gallery, picker);
        },
      ),
      MenuItem(
        label: "From Camera",
        icon: Icons.camera,
        onTap: () {
          Navigator.pop(context);
          getImage(ImageSource.camera, picker);
        },
      ),
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            title: const Text('Upload image'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Choose the upload source"),
                ],
              ),
            ),
            actions: buttons,
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    ImagePicker picker = ImagePicker();

    return PopupMenuButton(
      icon: const Icon(
        Icons.add_circle,
        size: 40,
      ),
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<int>(
            value: 0,
            child: MenuItem(label: "Send pictures", icon: Icons.photo),
          )
        ];
      },
      onSelected: (int value) {
        if (value == 0) {
          myAlert(context, picker);
        }
      },
    );
  }
}
