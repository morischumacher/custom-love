import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../config/api_config.dart';
import 'package:logger/logger.dart';

class Gender {
  int id;
  String name;

  Gender(this.id, this.name);

  factory Gender.fromJson(dynamic json) {
    return Gender(json['id'] as int, json['name'] as String);
  }

  @override
  String toString() {
    return '{ $id, $name }';
  }

  @override
  bool operator ==(other) => other is Gender && id == other.id && name == other.name;

  @override
  int get hashCode => Object.hash(id, name);
}

class GenderService {
  final Logger logger = Logger();

  Future<List<Gender>> getGenders() async {
    String url = "${ApiConfig.baseUrl}/gender-identities/";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var genderJson = jsonDecode(response.body)['items'] as List;
        List<Gender> genderObjs = genderJson.map((tagJson) => Gender.fromJson(tagJson)).toList();
        return genderObjs;
      }
    } catch (error) {
      logger.e('Error: $error');
    }
    return List<Gender>.empty();
  }
}
