import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mavx_flutter/app/core/services/notification_storage_service.dart';
import 'package:mavx_flutter/app/data/models/notification_model.dart';

class NotificationsController extends GetxController {
  final RxString currentFilter = 'all'.obs; // all | unread | read
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  ValueListenable<Box<String>>? _listenable;
  VoidCallback? _listenerDispose;

  @override
  void onInit() {
    super.onInit();
    _attachListenable();
    _load();
  }

  void _attachListenable() {
    _listenable = NotificationStorageService.listenable();
    if (_listenable != null) {
      _listenable!.addListener(_onBoxChanged);
      _listenerDispose = () => _listenable!.removeListener(_onBoxChanged);
    }
  }

  void _onBoxChanged() {
    _load();
  }

  void setFilter(String value) {
    if (currentFilter.value == value) return;
    currentFilter.value = value;
    _load();
  }

  void _load() {
    final all = NotificationStorageService.getAll();
    List<NotificationModel> filtered;
    switch (currentFilter.value) {
      case 'unread':
        filtered = all.where((n) => !n.isRead).toList();
        break;
      case 'read':
        filtered = all.where((n) => n.isRead).toList();
        break;
      case 'all':
      default:
        filtered = all;
        break;
    }
    notifications.assignAll(filtered);
  }

  Future<void> markAsRead(String id) async {
    await NotificationStorageService.markAsRead(id);
    _load();
  }

  Future<void> markAllAsRead() async {
    await NotificationStorageService.markAllAsRead();
    _load();
  }

  Future<void> delete(String id) async {
    await NotificationStorageService.delete(id);
    _load();
  }

  Future<void> refreshList() async {
    _load();
  }

  int unreadCount() => NotificationStorageService.unreadCount();

  @override
  void onClose() {
    _listenerDispose?.call();
    super.onClose();
  }
}
