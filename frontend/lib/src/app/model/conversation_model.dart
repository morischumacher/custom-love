class Conversation {
  int id;
  int user1Id;
  int user2Id;

  Conversation(this.id, this.user1Id, this.user2Id);

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(json['id'], json['user1_id'], json['user2_id']);
  }

  int? getOtherUserId(int? id) {
    if (id == null) {
      return null;
    }

    if (user1Id == id) {
      return user2Id;
    }

    return user1Id;
  }
}
