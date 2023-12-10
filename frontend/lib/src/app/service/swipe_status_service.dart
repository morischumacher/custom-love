import 'package:frontend/src/app/api/swipe_status_api.dart';

class SwipeStatusService {
  final SwipeStatusApi _swipeStatusApi;

  SwipeStatusService(this._swipeStatusApi);

  Future<String> postView(String token, int userId) async {
    try {
      final result = await _swipeStatusApi.postView(userId);
      return result;
    } catch (error) {
      print('Could not post view: $error');
      // Optionally rethrow the error if you want to handle it elsewhere
      rethrow;
    }
  }

  Future<String> postLike(String token, int userId) async {
    try {
      final result = await _swipeStatusApi.postLike(token, userId);
      return result;
    } catch (error) {
      print('Could not post like: $error');
      // Optionally rethrow the error if you want to handle it elsewhere
      rethrow;
    }
  }
}
