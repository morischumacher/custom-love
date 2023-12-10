class NotificationModel {
  String type;
  dynamic content;

  NotificationModel(this.type, this.content);
  NotificationModel.fromJson(dynamic json): this(json["type"], json["content"]);
}