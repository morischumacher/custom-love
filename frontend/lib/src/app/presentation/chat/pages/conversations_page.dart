import 'package:flutter/material.dart';
import 'package:frontend/src/app/model/user_model.dart';
import 'package:frontend/src/app/presentation/chat/components/avatar.dart';
import 'package:frontend/src/app/presentation/chat/components/list_tile.dart';
import 'package:frontend/src/app/presentation/chat/components/titled_list.dart';
import 'package:frontend/src/config/app_state.dart';
import 'package:provider/provider.dart';

import '../../../../config/theme.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({Key? key}) : super(key: key);

  @override
  _ConversationsPageState createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  final CustomLoveTheme _customLoveTheme = const CustomLoveTheme();

  @override
  Widget build(BuildContext context) {
    ScrollController matchesScrollController = ScrollController();
    ScrollController conversationsController = ScrollController();

    return Container(
      padding: EdgeInsets.symmetric(vertical: 2 * _customLoveTheme.universalPadding, horizontal: 0),
      child: Column(
        children: [
          Expanded(
              flex: 1,
              child: TitledList<MatchStorage>(
                title: 'Matches: ',
                controller: matchesScrollController,
                scrollDirection: Axis.horizontal,
                itemCount: (storage) => storage.matches.items.length,
                builder: (MatchStorage matchStorage, BuildContext context, int index) {
                  return Consumer<UserStorage>(
                    builder: (BuildContext context, UserStorage userStorage, Widget? child) {
                      if (userStorage.loading) {
                        return const CircularProgressIndicator();
                      }

                      User? user = userStorage.users.items.values.elementAtOrNull(index);
                      return Avatar(user);
                    },
                  );
                },
              )
          ),
          Expanded(
            flex: 5,
            child: TitledList<ConversationStorage>(
              title: 'Conversations: ',
              controller: conversationsController,
              itemCount: (storage) => storage.conversations.items.length,
              scrollDirection: Axis.vertical,
              builder: (ConversationStorage conversationStorage, BuildContext context, int index) {
                return Consumer<StateManager>(
                  builder: (BuildContext context, StateManager stateManager, Widget? child) {
                    return CustomListTile(
                        userId: stateManager.user?.id,
                        conversation: conversationStorage.conversations.items.values.elementAtOrNull(index)
                    );
                  },
                );
              },
            )
          )
        ],
      ),
    );
  }
}
