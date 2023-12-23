import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:frontend/src/config/api_config.dart';
import 'package:logger/logger.dart';

class Interest {
  int id;
  String name;

  Interest(this.id, this.name);

  factory Interest.fromJson(dynamic json) {
    return Interest(json['id'] as int, json['name'] as String);
  }

  @override
  String toString() {
    return '{ $id, $name }';
  }
}

class InterestService {
  final Logger logger = Logger();

  Future<List<Interest>> getInterests() async {
    String url = "${ApiConfig.baseUrl}/interests/";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var interestJson = jsonDecode(response.body)['items'] as List;
        List<Interest> interestObjs = interestJson.map((tagJson) => Interest.fromJson(tagJson)).toList();
        return interestObjs;
      }
    } catch (error) {
      logger.e('Error: $error');
    }
    return List<Interest>.empty();
  }
}
