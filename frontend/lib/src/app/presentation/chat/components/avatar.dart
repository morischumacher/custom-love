import 'package:flutter/material.dart';
import '../../../../config/theme.dart';
import '../../../model/user_model.dart';

class Avatar extends StatelessWidget {
  final String _initials;
  final ImageProvider? image;
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  const Avatar.withInitials(this._initials, {super.key, this.image});

  factory Avatar(User? user) {
    if (user == null) {
      return const Avatar.withInitials("");
    }

    return Avatar.withInitials("${user.firstName[0]}${user.lastName[0]}");
  }

  // TODO: implement avatars with images
  // Avatar.withImage(this._initials, this._image, {super.key});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fill,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
           CircleAvatar(
             backgroundColor: _customLoveTheme.grayscale1,
             backgroundImage: image,
           ),
           Text(
             _initials,
             textAlign: TextAlign.center,
             style: TextStyle(
               fontSize: 20,
               fontWeight: FontWeight.bold,
               color: _customLoveTheme.grayscale2,
             ),
           ),
         ],
      ),
    );
  }
  
}