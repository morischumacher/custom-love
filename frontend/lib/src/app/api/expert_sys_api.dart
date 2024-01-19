import "dart:convert";
import "package:frontend/src/config/api_config.dart";
import "package:http/http.dart" as http;

class ExpertSysApi {
  final http.Client httpClient;

  ExpertSysApi({required this.httpClient});

  Future<String> postExpertSys(String accessToken,
      List<int> swipeDecisions) async {

    final response = await httpClient.post(
        Uri.parse('${ApiConfig.baseUrl}/train/model'),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(swipeDecisions),
    );

    if (response.statusCode == 200) {
      return response.toString();
    } else {
      throw Exception('Could not create expert system');
    }
  }
}