import 'package:mavx_flutter/app/domain/repositories/notification_repository.dart';

class MarkNotificationAsReadUseCase {
  final NotificationRepository repository;

  MarkNotificationAsReadUseCase(this.repository);

  Future<void> call(String notificationId) async {
    await repository.markAsRead(notificationId);
  }
}

class MarkAllNotificationsAsReadUseCase {
  final NotificationRepository repository;

  MarkAllNotificationsAsReadUseCase(this.repository);

  Future<void> call() async {
    await repository.markAllAsRead();
  }
}

class DeleteNotificationUseCase {
  final NotificationRepository repository;

  DeleteNotificationUseCase(this.repository);

  Future<void> call(String notificationId) async {
    await repository.deleteNotification(notificationId);
  }
}

class GetUnreadNotificationCountUseCase {
  final NotificationRepository repository;

  GetUnreadNotificationCountUseCase(this.repository);

  Future<int> call() async {
    return await repository.getUnreadCount();
  }
} 