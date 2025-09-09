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
    await _box().put(model.id, jsonEncode(model.toJson()));
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
