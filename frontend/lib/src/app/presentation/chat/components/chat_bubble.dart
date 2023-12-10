import 'package:flutter/cupertino.dart';
import 'package:frontend/src/config/theme.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final CustomLoveTheme _theme = const CustomLoveTheme();
  final bool isSender;

  const ChatBubble(this.message, this.isSender, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: _theme.universalPadding, horizontal: _theme.universalPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_theme.universalPadding),
        color: isSender ? _theme.primaryColor : _theme.grayscale1,
      ),
      child: Text(
        message,
        style: TextStyle(
            fontSize: 16,
            color: isSender ? _theme.whiteColor : _theme.textColor,
        ),
      ),
    );
  }

}