import '../../../model/user_model.dart';
import '../../../service/user_service.dart';
import '../../authentification/controller/login_controller.dart';

class SwipesLeft {
  static Future<int> updateSwipeLeft(LoginController controller, UserService userService) async {
    String accessToken = await controller.retrieveAccessToken() as String;
    int tmpSwipesLeft = 0;
    print("AccessToken from user logged in: $accessToken");
    await userService.updateCurrentUserSwipesLeft(accessToken).then((User? user) {
      print("swipes left: " + user!.swipes_left.toString());
      tmpSwipesLeft = user.swipes_left;
      if(tmpSwipesLeft == 0) {
        print("swipe limit reached");
      }
    });
    return tmpSwipesLeft;
  }

}