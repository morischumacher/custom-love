import 'package:flutter/cupertino.dart';
import 'package:frontend/src/app/presentation/chat/pages/conversations_page.dart';
import "package:universal_html/html.dart" as universal_html;

import 'messages_page.dart';

class MatchesPage extends StatelessWidget {

  const MatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var url = universal_html.window.location.href;
    List<String> urlSubsections = url.split("/");
    String subRoute = urlSubsections[urlSubsections.length - 1].toLowerCase();

    if (subRoute == "messages") {
      return const MessagesPage();
    } else {
      return const ConversationsPage();
    }
  }
}