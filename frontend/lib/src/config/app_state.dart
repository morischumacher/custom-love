import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/src/app/model/collection_model.dart';
import 'package:frontend/src/app/presentation/authentification/pages/logout_page.dart';
import 'package:frontend/src/app/service/match_service.dart';
import 'package:frontend/src/app/service/message_service.dart';
import 'package:frontend/src/app/service/user_service.dart';
import 'package:frontend/src/config/api_config.dart';
import 'package:frontend/src/config/exceptions.dart';
import 'package:provider/provider.dart';

import '../app/api/helpers/jwt_api.dart';
import '../app/model/conversation_model.dart';
import '../app/model/notification_model.dart';
import '../app/model/user_model.dart';
import '../app/model/match_model.dart';
import '../app/model/message_model.dart';
import '../app/service/conversation_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class CollectionStorage extends ChangeNotifier {
  bool loading = false;
  bool initiated = false;
}

class UserStorage extends CollectionStorage {
  Collection<User> users = Collection<User>();
}

class ConversationStorage extends CollectionStorage {
  Collection<Conversation> conversations = Collection<Conversation>();
}

class MessageStorage extends CollectionStorage {
  Map<int, Collection<Message>> messages = <int, Collection<Message>>{};
}

class MatchStorage extends CollectionStorage {
  Collection<Match> matches = Collection<Match>();
}

class StateManager extends ChangeNotifier {
  User? user;
  WebSocketChannel? socket;
  bool connected = false;
  int loginRetries = 10;

  Future<void> registerUser(User user, BuildContext buildContext) async {
    // save the current user
    this.user = user;

    if (!buildContext.mounted) return;
    await connect(buildContext);
  }

  Future<void> initialize(BuildContext buildContext) async {
    List<Future<void>> tasks = List<Future<void>>.from({
      initializeUsers(buildContext),
      initializeConversations(buildContext),
      initializeMatches(buildContext)
    });

    for (Future<void> task in tasks) {
      await task;
    }
  }
  
  Future<void> initializeUsers(BuildContext buildContext) async {
    UserService userService = buildContext.read<UserService>();
    UserStorage userStorage = Provider.of<UserStorage>(buildContext, listen: false);

    if (userStorage.initiated) {
      // make sure the loading flag is off
      userStorage.loading = false;
      
      // do nothing
      return;
    }
    
    // set the loading flag and load all users
    userStorage.loading = true;
    await userStorage.users.getAll(userService);
    
    userStorage.loading = false;
    userStorage.initiated = true;

    userStorage.notifyListeners();
  }
  
  Future<void> initializeConversations(BuildContext buildContext) async {
    ConversationService conversationService = buildContext.read<ConversationService>();
    MessageService messageService = buildContext.read<MessageService>();

    ConversationStorage conversationStorage = Provider.of<ConversationStorage>(buildContext, listen: false);
    MessageStorage messageStorage = Provider.of<MessageStorage>(buildContext, listen: false);


    if (conversationStorage.initiated && messageStorage.initiated) {
      conversationStorage.loading = false;
      messageStorage.loading = false;
      
      return;
    }
    
    conversationStorage.loading = true;
    await conversationStorage.conversations.getAll(conversationService);

    conversationStorage.loading = false;
    conversationStorage.initiated = true;

    conversationStorage.notifyListeners();

    messageStorage.loading = true;
    List<Future<void>> tasks = List<Future<void>>.empty(growable: true);
    for (int c in conversationStorage.conversations.items.keys) {
      Collection<Message> m = Collection<Message>();

      // we load the first message for every conversation
      tasks.add(m.getFirst(messageService.copyWith("$c")));

      messageStorage.messages.putIfAbsent(c, () => m);
    }

    for (Future<void> task in tasks) {
      await task;
    }

    messageStorage.loading = false;
    messageStorage.initiated = true;

    messageStorage.notifyListeners();
  }

  Future<void> initializeMatches(BuildContext buildContext) async {
    MatchService matchService = buildContext.read<MatchService>();
    MatchStorage matchStorage = Provider.of<MatchStorage>(buildContext, listen: false);

    if (matchStorage.initiated) {
      matchStorage.loading = false;
      return;
    }

    matchStorage.loading = true;
    await matchStorage.matches.getAll(matchService);

    matchStorage.loading = false;

    matchStorage.notifyListeners();
  }

  Future<void> connect(BuildContext buildContext) async {
    // get the token
    String? token = await JWTApi.retrieveAccessToken();

    // subscribe to a websocket
    socket = WebSocketChannel.connect(
        Uri.parse("${ApiConfig.socketsUrl}/users/socket/$token")
    );

    socket?.stream.listen(
      (event) {
        NotificationModel notification = NotificationModel.fromJson(event);
        switch(notification.type) {
          case "message":
            print(event);
        }
      },
      onDone: () {
        // ignore the callback when the closeCode is null
        // the event will be handled in the onError callback
        if (socket?.closeCode == null) {
          // do nothing
          print("onDone did nothing");
          return;
        }

        // update the connected flag
        connected = false;
        notifyListeners();

        if (socket?.closeReason == "logout") {
          user = null;
          Navigator.of(buildContext).pushNamed(
            "/logout",
            arguments: const LogoutRouteArguments("You have logged in on more than 10 devices. You have been logged out of this device"),
          );

          return;
        }

        // reconnect to the webSocket if the connection has been closed
        unawaited(connect(buildContext));
      },
      onError: (error) {
        // update the connected flag
        connected = false;
        notifyListeners();

        // if the retry threshold has been exceeded, logout
        if (loginRetries <= 0) {
          loginRetries = 10;
          user = null;
          Navigator.of(buildContext).pushNamed(
            "/logout",
            arguments: const LogoutRouteArguments("The server is unreachable, you have been logged out."),
          );

          return;
        }

        // TODO: there should be a sleep(x seconds)
        // TODO: implement a background worker
        loginRetries -= 1;

        // try to reconnect to the socket
        unawaited(connect(buildContext));
      }
    );

    // set the connected flag to true
    try {
      await socket?.ready;
      connected = true;
      notifyListeners();
    } catch(e) {
      // do nothing
    }
  }
}