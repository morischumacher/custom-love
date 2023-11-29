import 'dart:convert';

import 'package:frontend/src/app/api/helpers/pagination_api.dart';
import 'package:frontend/src/app/model/factories/user_factory.dart';
import 'package:frontend/src/app/model/user_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/src/config/api_config.dart';
import 'package:logger/logger.dart';

import 'interfaces/paginated_api.dart';

class UserApi extends PaginatedApi<User> {
  final logger = Logger();

  UserApi(http.Client client): super(client, "users/", UserFactory());
  UserApi.url(http.Client client, String urlParams): super(client, "users/$urlParams", UserFactory());

  @override
  UserApi copyWith(String urlParams) =>
      UserApi.url(
          client,
          urlParams
      );

  Future<User> updateUserLocation(
      Position userPosition, var accessToken) async {
    final Map<String, dynamic> body = {
      "latitude": userPosition.latitude,
      "longitude": userPosition.longitude,
    };

    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/users'),
      headers: {
        'Content-Type': 'application/json',
        'accept': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final dynamic jsonItem = json.decode(response.body);
      final User user = User.fromJson(jsonItem);
      return user;
    } else {
      // TODO: Add custom exception
      throw Exception('Failed to update user');
    }
  }
}
