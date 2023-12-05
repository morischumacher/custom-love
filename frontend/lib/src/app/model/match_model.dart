class Match {
  int id;
  int user1Id;
  int user2Id;

  Match(this.id, this.user1Id, this.user2Id);

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match (
      json['id'],
      json['user1_id'],
      json['user2_id']
    );
  }

  int getOtherUserId(int id) {
    if (user1Id == id) {
      return user2Id;
    }

    return user1Id;
  }
}