class NotificationModel {
  final String id;
  final String type;
  final String content;
  final bool isRead;
  final DateTime createdAt;
  final String userId;

  NotificationModel({
    required this.id,
    required this.type,
    required this.content,
    required this.isRead,
    required this.createdAt,
    required this.userId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      type: json['type'],
      content: json['content'],
      isRead: json['is_read'],
      createdAt: DateTime.parse(json['created_at']),
      userId: json['user_id'],
    );
  }
}
