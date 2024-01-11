enum SwipeState {
  OKAY, // 0
  NO_SWIPES_LEFT, // 2
  NO_SURROUNDING_USERS, // 3
}

class SwipeStateHelper {
  static SwipeState getByValue(int value) {
    switch (value) {
      case 0:
        return SwipeState.OKAY;
      case 1:
        return SwipeState.NO_SWIPES_LEFT;
      case 2:
        return SwipeState.NO_SURROUNDING_USERS;
      default:
        return SwipeState.NO_SURROUNDING_USERS;
    }
  }
}