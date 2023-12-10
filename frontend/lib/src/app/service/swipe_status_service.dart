import 'package:frontend/src/app/api/swipe_status_api.dart';

class SwipeStatusService {
  final SwipeStatusApi _swipeStatusApi;

  SwipeStatusService(this._swipeStatusApi);

  Future<String> postView(String token, int userId) async {
    try {
      // You need to await the result of _viewApi.postView
      final result = await _swipeStatusApi.postView(userId);
      return result; // Assuming postView returns a String, adjust if needed
    } catch (error) {
      print('Could not post view: $error');
      // Optionally rethrow the error if you want to handle it elsewhere
      rethrow;
    }
  }

  Future<String> postLike(String token, int userId) async {
    try {
      // You need to await the result of _viewApi.postView
      final result = await _swipeStatusApi.postView(userId);
      return result; // Assuming postView returns a String, adjust if needed
    } catch (error) {
      print('Could not post like: $error');
      // Optionally rethrow the error if you want to handle it elsewhere
      rethrow;
    }
  }
}
