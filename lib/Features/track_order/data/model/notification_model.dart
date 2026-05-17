class NotificationModel {
  final String id;
  final String receiverId;
  final String title;
  final String body;
  final DateTime sentAt;
  final bool isRead;
  final Map<String, dynamic>? metadata;

  NotificationModel({
    required this.id,
    required this.receiverId,
    required this.title,
    required this.body,
    required this.sentAt,
    this.isRead = false,
    this.metadata,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'receiverId': receiverId,
    'title': title,
    'body': body,
    'sentAt': sentAt,
    'isRead': isRead,
    'metadata': metadata,
  };
}