import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/src/app/service/view_service.dart';
import 'package:provider/provider.dart';

class SwipeController {
  Future<void> view(int userId) async {
    // TODO: set
    ViewService viewService = ViewService();
    viewService.postView(userId);
    print("User disliked $userId");
  }
}
