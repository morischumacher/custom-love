import 'package:flutter/cupertino.dart';
import 'package:frontend/src/app/presentation/swipe/util/swipe_state.dart';

class SwipeStateNotifier extends ChangeNotifier {
  SwipeState _swipeState = SwipeState.NO_ALGORITHM_SELECTED;

  SwipeState get swipeState => _swipeState;

  void setAlgoId(SwipeState swipeState) {
    _swipeState = swipeState;
    notifyListeners();
  }
}