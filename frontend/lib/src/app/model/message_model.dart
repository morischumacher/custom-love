class Message {
  int id;
  int conversationId;
  int senderId;
  int receiverId;
  String message;
  DateTime timestamp;

  Message(this.id, this.conversationId, this.senderId, this.receiverId, this.message, this.timestamp);

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      json['id'],
      json['conversation_id'],
      json['sender_id'],
      json['receiver_id'],
      json['message'],
      DateTime.parse(json['timestamp'])
    );
  }

  String getPreview({int length = 40}) {
    if (message.length > length) {
      return "${message.substring(0, length)}...";
    }

    return message;
  }
}