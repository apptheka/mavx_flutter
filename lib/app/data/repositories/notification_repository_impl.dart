import 'package:mavx_flutter/app/core/services/notification_storage_service.dart';
import 'package:mavx_flutter/app/data/models/notification_model.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart';
import 'package:mavx_flutter/app/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final ApiProvider apiProvider;

  NotificationRepositoryImpl({required this.apiProvider});

  @override
  Future<List<NotificationModel>> getNotifications() async {
    // Later: fetch from API and merge; for now, return persisted local notifications
    return NotificationStorageService.getAll(); 
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await NotificationStorageService.markAsRead(notificationId);
  }

  @override
  Future<void> markAllAsRead() async {
    await NotificationStorageService.markAllAsRead();
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await NotificationStorageService.delete(notificationId);
  }

  @override
  Future<int> getUnreadCount() async {
    return NotificationStorageService.unreadCount();
  }

  @override
  Future<bool> removeDevice() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
} 