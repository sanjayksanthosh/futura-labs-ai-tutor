class ActivityModel {
  final String id;
  final String type;
  final String title;
  final String description;
  final String? courseName;
  final DateTime timestamp;
  final String? iconUrl;

  ActivityModel({
    required this.id,
    required this.type,
    required this.title,
    this.description = '',
    this.courseName,
    DateTime? timestamp,
    this.iconUrl,
  }) : timestamp = timestamp ?? DateTime.now();

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      courseName: json['courseName'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      iconUrl: json['iconUrl'] as String?,
    );
  }
}

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.type = 'info',
    this.isRead = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: json['type'] as String? ?? 'info',
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
