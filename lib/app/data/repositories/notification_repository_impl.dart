import 'dart:convert';

import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/services/extensions.dart';
import 'package:mavx_flutter/app/core/services/notification_storage_service.dart';
import 'package:mavx_flutter/app/data/models/notification_model.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart';
import 'package:mavx_flutter/app/domain/repositories/notification_repository.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/domain/repositories/auth_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final ApiProvider apiProvider;
  final AuthRepository authRepository = Get.find<AuthRepository>();

  NotificationRepositoryImpl({required this.apiProvider});

  @override
  Future<List<NotificationModel>> getNotifications() async {
   try {
     // Build query params similar to provided curl
     final currentUser = await authRepository.getCurrentUser();
     final userId = currentUser?.data.id;
     final params = <String, dynamic>{
       'userId': userId,
       'type': 'expert',
       'isRead': 0,
       'fromDate': null,
       'toDate': null,
       'limit': 10000,
       'offset': 0,
     };

     final respStr = await apiProvider.get(
       AppConstants.notificationsList,
       queryParameters: params,
     );

     // Response could be plaintext JSON or encrypted string
     dynamic decoded;
     try {
       decoded = jsonDecode(respStr);
     } catch (_) {
       try {
         decoded = jsonDecode(respStr.decrypt());
       } catch (__) {
         // If it's neither JSON nor encrypted JSON, fallback to local
         return NotificationStorageService.getAll();
       }
     }

     // Extract list payload from common shapes
     List listPayload;
     if (decoded is Map && decoded['data'] is List) {
       listPayload = decoded['data'];
     } else if (decoded is Map && decoded['notifications'] is List) {
       listPayload = decoded['notifications'];
     } else if (decoded is List) {
       listPayload = decoded;
     } else {
       // Unknown shape -> fallback to local
       return NotificationStorageService.getAll();
     }

     final items = listPayload
         .whereType<Map<String, dynamic>>()
         .map((e) => NotificationModel.fromJson(e))
         .toList();

     return items;
   } catch (e) {
     return NotificationStorageService.getAll();
   }
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
 