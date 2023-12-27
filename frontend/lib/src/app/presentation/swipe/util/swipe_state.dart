enum SwipeState {
  OKAY, // 0
  NO_MATCH_SUGGESTIONS, // 1
  NO_SWIPES_LEFT, // 2
  NO_SURROUNDING_USER, // 3
  NO_ALGORITHM_SELECTED // 4
}

class SwipeStateHelper {
  static SwipeState getByValue(int value) {
    switch (value) {
      case 0:
        return SwipeState.OKAY;
      case 1:
        return SwipeState.NO_MATCH_SUGGESTIONS;
      case 2:
        return SwipeState.NO_SWIPES_LEFT;
      case 3:
        return SwipeState.NO_SURROUNDING_USER;
      default:
        return SwipeState.NO_ALGORITHM_SELECTED;
    }
  }
}