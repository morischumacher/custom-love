import 'dart:convert';

class Message {
  int? id;
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'timestamp': timestamp.toString()
    };
  }

  String getPreview({int length = 40}) {
    if (message.length > length) {
      return "${message.substring(0, length)}...";
    }

    return message;
  }
}