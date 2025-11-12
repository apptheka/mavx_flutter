import 'dart:convert';
import 'dart:developer';

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
     // Build params, matching backend expectations from provided curl
    final Map<String, dynamic> params = {
      if (userId != null) 'userId': userId,
      'type': 'expert',
      'isRead': 0,
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
       log("hdiushfiushdfsdfsiufhsiufdh$decoded");
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
    } else if (decoded is Map && decoded['list'] is List) {
      listPayload = decoded['list'];
    } else if (decoded is Map && decoded['rows'] is List) {
      listPayload = decoded['rows'];
    } else if (decoded is List) {
      listPayload = decoded;
    } else {
      // Unknown shape -> fallback to local
      return NotificationStorageService.getAll();
    }

    DateTime _parseDate(dynamic v) {
      if (v == null) return DateTime.now();
      if (v is int) {
        // If small value, treat as seconds since epoch; otherwise milliseconds
        final isSeconds = v.abs() < 1000000000000; // ~ Sat Nov 20 33658
        final ms = isSeconds ? v * 1000 : v;
        return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true).toLocal();
      }
      if (v is String && v.isNotEmpty) {
        // Numeric string epoch
        final num? n = num.tryParse(v);
        if (n != null) {
          final isSeconds = n.abs() < 1000000000000;
          final ms = isSeconds ? n.toInt() * 1000 : n.toInt();
          return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true).toLocal();
        }
        try {
          final parsed = DateTime.parse(v);
          // Detect timezone in string: 'Z' or "+HH:MM" suffix
          final hasTz = RegExp(r'(Z|[+-]\d{2}:?\d{2})$').hasMatch(v);
          if (hasTz) return parsed.toLocal();
          // No timezone -> treat as UTC and convert to local
          final asUtc = DateTime.utc(
            parsed.year,
            parsed.month,
            parsed.day,
            parsed.hour,
            parsed.minute,
            parsed.second,
            parsed.millisecond,
            parsed.microsecond,
          );
          return asUtc.toLocal();
        } catch (_) {}
      }
      return DateTime.now();
    }

    bool _parseBool(dynamic v) {
      if (v is bool) return v;
      if (v is num) return v != 0;
      if (v is String) return v.toLowerCase() == 'true' || v == '1';
      return false;
    }

    String _firstNonEmpty(Map<String, dynamic> m, List<String> keys) {
      for (final k in keys) {
        final val = m[k];
        if (val != null && val.toString().trim().isNotEmpty) return val.toString();
      }
      return '';
    }

    final items = <NotificationModel>[];
    for (final m in listPayload.whereType<Map<String, dynamic>>()) {
      final id = _firstNonEmpty(m, ['id', 'notificationId', '_id', 'uuid']);
      final title = _firstNonEmpty(m, ['title', 'subject', 'heading']);
      final message = _firstNonEmpty(m, ['message', 'body', 'description', 'content']);
      final type = _firstNonEmpty(m, ['type', 'category', 'kind']);
      final created = _parseDate(m['created_at'] ?? m['createdAt'] ?? m['createdOn'] ?? m['createdDate']);
      final isRead = _parseBool(m['is_read'] ?? m['isRead'] ?? m['read']);

      items.add(
        NotificationModel(
          id: id.isNotEmpty ? id : DateTime.now().microsecondsSinceEpoch.toString(),
          title: title,
          message: message,
          type: type.isNotEmpty ? type : 'general',
          createdAt: created,
          isRead: isRead,
        ),
      );
    }

    // Preserve local read state: if an item was read locally, keep it read
    try {
      final local = NotificationStorageService.getAll();
      final readIds = local.where((n) => n.isRead).map((n) => n.id).toSet();
      final merged = items
          .map((n) => readIds.contains(n.id)
              ? NotificationModel(
                  id: n.id,
                  title: n.title,
                  message: n.message,
                  type: n.type,
                  createdAt: n.createdAt,
                  isRead: true,
                )
              : n)
          .toList();
      return merged;
    } catch (_) {
      return items;
    }
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
 