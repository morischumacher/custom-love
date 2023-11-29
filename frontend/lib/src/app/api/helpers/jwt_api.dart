import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../config/api_config.dart';

class JWTApi {
  String _token;

  JWTApi(this._token);

  Future<http.Response> get(http.Client client, String url) async {
    http.Response response = await client.get(Uri.parse('${ApiConfig.baseUrl}/$url'),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
          'Authorization': 'Bearer $_token',
        });

    if (response.statusCode == 422) {
      // TODO: handle token refresh
      throw Exception('JWT is corrupt');
    }

    return response;
  }
}