import '../../../model/user_model.dart';
import '../../../service/user_service.dart';

class MatchingAlgorithm {
  static Future<int> updateMatchingAlgorithm(String accessToken, UserService userService, int algoId) async {
    int tmpMatchingAlgorithm = 0;
    await userService.updateCurrentUserMatchingAlgorithm(accessToken, algoId).then((User? user) {
      tmpMatchingAlgorithm = user!.matching_algorithm;
    });
    return tmpMatchingAlgorithm;
  }

  static Future<int> getCurrentMatchingAlgorithm(int userId, UserService userService) async {
    int tmpMatchingAlgorithm = 0;
    await userService.getUser(userId).then((User? user) {
      tmpMatchingAlgorithm = user!.matching_algorithm;
    });
    return tmpMatchingAlgorithm;
  }

}