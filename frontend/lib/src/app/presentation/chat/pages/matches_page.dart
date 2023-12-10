import 'package:flutter/cupertino.dart';
import 'package:frontend/src/app/presentation/chat/pages/conversations_page.dart';
import "package:universal_html/html.dart" as universal_html;

import '../../authentification/pages/logout_page.dart';
import 'messages_page.dart';

class MatchesPage extends StatelessWidget {

  const MatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // navigator is corrupt - logout
    if (ModalRoute.of(context) == null) {
      Navigator.of(context).pushNamed(
        "/logout",
        arguments: const LogoutRouteArguments("Internal App Error: Navigator corrupt"),
      );
    }

    var url = ModalRoute.of(context)!.settings.name!;
    List<String> urlSubsections = url.split("/");
    String subRoute = urlSubsections[urlSubsections.length - 1].toLowerCase();

    if (subRoute == "messages") {
      return const MessagesPage();
    } else {
      return const ConversationsPage();
    }
  }
}