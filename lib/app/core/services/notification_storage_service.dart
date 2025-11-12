import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mavx_flutter/app/data/models/notification_model.dart';

class NotificationStorageService {
  static const String boxName = 'notifications_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<String>(boxName);
    }
  }

  static Box<String> _box() => Hive.box<String>(boxName);

  static Future<void> ensureOpen() async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<String>(boxName);
    }
    // Run a lightweight migration to normalize legacy timestamps
    await _normalizeLegacyTimestamps();
  }

  static Future<void> _normalizeLegacyTimestamps() async {
    final box = _box();
    for (final key in box.keys) {
      final val = box.get(key);
      if (val == null) continue;
      try {
        final map = jsonDecode(val) as Map<String, dynamic>;
        final ts = map['created_at'];
        int? utcEpochMs;
        if (ts is String && ts.isNotEmpty) {
          // If it looks like an ISO string without timezone, assume it was saved as local and convert to UTC
          final hasTz = RegExp(r'(Z|[+-]\d{2}:?\d{2})$').hasMatch(ts);
          final parsed = DateTime.tryParse(ts);
          if (parsed != null) {
            if (!hasTz) {
              // Legacy local naive -> toUtc epoch
              utcEpochMs = DateTime.utc(
                parsed.year,
                parsed.month,
                parsed.day,
                parsed.hour,
                parsed.minute,
                parsed.second,
                parsed.millisecond,
                parsed.microsecond,
              ).millisecondsSinceEpoch;
            } else {
              utcEpochMs = parsed.toUtc().millisecondsSinceEpoch;
            }
          }
        } else if (ts is num) {
          // seconds vs ms
          final isSeconds = ts.abs() < 1000000000000;
          final ms = isSeconds ? ts.toInt() * 1000 : ts.toInt();
          utcEpochMs = DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true)
              .millisecondsSinceEpoch;
        }
        if (utcEpochMs != null) {
          map['created_at'] = utcEpochMs;
          await box.put(key, jsonEncode(map));
        }
      } catch (_) {
        // ignore bad rows
      }
    }
  }

  static List<NotificationModel> getAll() {
    if (!Hive.isBoxOpen(boxName)) return [];
    return _box()
        .values
        .map((e) => NotificationModel.fromJson(jsonDecode(e)))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  static Future<void> save(NotificationModel model) async {
    await ensureOpen();
    // Persist created_at as UTC epoch milliseconds to avoid tz ambiguity
    final map = model.toJson();
    map['created_at'] = model.createdAt.toUtc().millisecondsSinceEpoch;
    await _box().put(model.id, jsonEncode(map));
  }

  static Future<void> saveFromRemoteMessage(RemoteMessage message) async {
    final id = message.messageId ?? DateTime.now().millisecondsSinceEpoch.toString();
    final title = message.notification?.title ?? message.data['title'] ?? '';
    final body = message.notification?.body ?? message.data['body'] ?? '';
    final type = (message.data['type'] ?? 'general').toString();

    final model = NotificationModel(
      id: id,
      title: title,
      message: body,
      type: type,
      createdAt: DateTime.now(),
      isRead: false,
    );
    await save(model);
  }

  static Future<void> markAsRead(String id) async {
    final current = _box().get(id);
    if (current == null) return;
    final json = jsonDecode(current) as Map<String, dynamic>;
    json['is_read'] = true;
    await _box().put(id, jsonEncode(json));
  }

  static Future<void> markAllAsRead() async {
    final box = _box();
    for (final key in box.keys) {
      final current = box.get(key);
      if (current == null) continue;
      final json = jsonDecode(current) as Map<String, dynamic>;
      json['is_read'] = true;
      await box.put(key, jsonEncode(json));
    }
  }

  static Future<void> delete(String id) async {
    if (!Hive.isBoxOpen(boxName)) return;
    await _box().delete(id);
  }

  static int unreadCount() {
    if (!Hive.isBoxOpen(boxName)) return 0;
    return _box().values
        .map((e) => NotificationModel.fromJson(jsonDecode(e)))
        .where((n) => !n.isRead)
        .length;
  }

  static ValueListenable<Box<String>>? listenable() {
    if (!Hive.isBoxOpen(boxName)) return null;
    return _box().listenable();
  }

  // Clear all notifications and close the box safely
  static Future<void> clearAll() async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox<String>(boxName);
      }
      await _box().clear();
      await Hive.box<String>(boxName).compact();
      await Hive.box<String>(boxName).close();
    } catch (_) {
      // ignore errors during cleanup
    }
  }
}
