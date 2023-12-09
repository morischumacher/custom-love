import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/src/app/model/collection_model.dart';
import 'package:frontend/src/app/service/match_service.dart';
import 'package:frontend/src/app/service/message_service.dart';
import 'package:frontend/src/app/service/user_service.dart';
import 'package:frontend/src/config/api_config.dart';

import '../app/api/helpers/jwt_api.dart';
import '../app/model/conversation_model.dart';
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

  Future<void> registerUser(User user) async {
    // save the current user
    this.user = user;

    // get the token
    String? token = await JWTApi.retrieveAccessToken();

    // subscribe to a websocket
    socket = WebSocketChannel.connect(
      Uri.parse("${ApiConfig.socketsUrl}/users/socket/$token")
    );

    socket?.stream.listen((event) {
      print(event);
    });
  }

  Future<void> initialize(
      UserStorage userStorage,
      ConversationStorage conversationStorage, 
      MessageStorage messageStorage,
      MatchStorage matchStorage,
      UserService userService,
      ConversationService conversationService,
      MessageService messageService,
      MatchService matchService
      ) async {
    List<Future<void>> tasks = List<Future<void>>.from({
      initializeUsers(userStorage, userService),
      initializeConversations(conversationStorage, conversationService, messageStorage, messageService),
      initializeMatches(matchStorage, matchService)
    });

    for (Future<void> task in tasks) {
      await task;
    }
  }
  
  Future<void> initializeUsers(UserStorage userStorage, UserService userService) async {
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
  
  Future<void> initializeConversations(
      ConversationStorage conversationStorage, 
      ConversationService conversationService, 
      MessageStorage messageStorage, 
      MessageService messageService
      ) async {
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

  Future<void> initializeMatches(MatchStorage matchStorage, MatchService matchService) async {
    if (matchStorage.initiated) {
      matchStorage.loading = false;
      return;
    }

    matchStorage.loading = true;
    await matchStorage.matches.getAll(matchService);

    matchStorage.loading = false;

    matchStorage.notifyListeners();
  }
}