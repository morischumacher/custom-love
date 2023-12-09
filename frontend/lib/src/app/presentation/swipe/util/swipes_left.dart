import '../../../model/user_model.dart';
import '../../../service/user_service.dart';
import '../../authentification/controller/login_controller.dart';

class SwipesLeft {
  static Future<int> updateSwipeLeft(LoginController controller, UserService userService) async {
    String accessToken = await controller.retrieveAccessToken() as String;
    int tmpSwipesLeft = 0;
    await userService.updateCurrentUserSwipesLeft(accessToken).then((User? user) {
      tmpSwipesLeft = user!.swipes_left;
      if(tmpSwipesLeft == 0) {
        print("swipe limit reached");
      }
    });
    return tmpSwipesLeft;
  }

  static Future<int> getCurrentSwipesLeft(int userId, UserService userService) async {
    int tmpSwipesLeft = 0;
    await userService.getUser(userId).then((User? user) {
      tmpSwipesLeft = user!.swipes_left;
    });
    return tmpSwipesLeft;
  }

}