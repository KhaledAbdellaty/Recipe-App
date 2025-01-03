enum NotificationType {
  like,
  comment,
  rating,
}

class NotificationMessage {
  final String title;
  final String body;

  NotificationMessage({
    required this.title,
    required this.body,
  });
}
