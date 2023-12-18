import '../../../model/user_model.dart';
import '../../../service/swipe_status_service.dart';
import '../../authentification/controller/login_controller.dart';

class SwipeStatus {
  static Future<void> view(LoginController controller, SwipeStatusService viewService, int userId) async {
    String accessToken = await controller.retrieveAccessToken() as String;
    await viewService.postView(accessToken, userId).then((value) {});
  }
}
