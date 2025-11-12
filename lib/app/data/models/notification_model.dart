class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    DateTime _parseToLocal(dynamic v) {
      if (v == null) return DateTime.now();
      if (v is int) {
        // assume milliseconds since epoch
        return DateTime.fromMillisecondsSinceEpoch(v).toLocal();
      }
      if (v is String && v.isNotEmpty) {
        // Try ISO first
        try {
          return DateTime.parse(v).toLocal();
        } catch (_) {
          // Try numeric epoch (ms or s)
          final num? n = num.tryParse(v);
          if (n != null) {
            final ms = n > 2000000000 ? n.toInt() : (n.toInt() * 1000);
            return DateTime.fromMillisecondsSinceEpoch(ms).toLocal();
          }
        }
      }
      return DateTime.now();
    }
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'general',
      createdAt: _parseToLocal(json['created_at'] ?? json['createdAt'] ?? json['createdOn'] ?? json['createdDate']),
      isRead: json['is_read'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
    };
  }
} 