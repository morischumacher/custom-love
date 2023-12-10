import 'package:frontend/src/app/api/view_api.dart';

class ViewService {
  final ViewApi _viewApi;

  ViewService(this._viewApi);

  Future<String> postView(int userId) async {
    try {
      // You need to await the result of _viewApi.postView
      final result = await _viewApi.postView(userId);
      return result; // Assuming postView returns a String, adjust if needed
    } catch (error) {
      print('Could not post view: $error');
      // Optionally rethrow the error if you want to handle it elsewhere
      rethrow;
    }
  }
}
