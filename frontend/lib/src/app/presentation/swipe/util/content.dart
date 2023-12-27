class Content {
  final String? id;
  final String? firstName;
  final String? bio;
  final List<String>? languages;
  final List<dynamic>? interests;
  final int? age;
  final String? city;
  final int? distance;
  Content(
      {this.firstName,
      this.id,
      this.age,
      this.city,
      this.languages,
      this.bio,
      this.interests,
      this.distance});
}
