import "package:frontend/src/config/api_config.dart";
import "package:http/http.dart" as http;

class SwipeStatusApi {
  final http.Client httpClient;

  SwipeStatusApi({required this.httpClient});

  Future<String> postView(int userId) async {
    final response = await httpClient.post(Uri.parse('${ApiConfig.baseUrl}/swipe_statuses/view/$userId'));

    if (response.statusCode == 200) {
      return response.toString();
    } else {
      throw Exception('Could not post view');
    }
  }

  Future<String> postLike(int userId) async {
    final response = await httpClient.post(Uri.parse('${ApiConfig.baseUrl}/swipe_statuses/like/$userId'));

    if (response.statusCode == 200) {
      return response.toString();
    } else {
      throw Exception('Could not post like');
    }
  }
}
