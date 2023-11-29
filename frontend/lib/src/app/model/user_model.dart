import 'dart:collection';

import 'package:frontend/src/app/presentation/chat/components/avatar.dart';

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String job;
  final String bio;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.job,
    required this.bio,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      job: json['job'] as String,
      bio: json['bio'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'job': job,
      'bio': bio,
    };
  }
}
