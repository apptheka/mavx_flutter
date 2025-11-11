import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:mavx_flutter/app/core/services/notification_storage_service.dart';
import 'package:mavx_flutter/app/data/models/notification_model.dart';
import 'package:mavx_flutter/app/domain/repositories/notification_repository.dart';

class NotificationsController extends GetxController {
  final RxString currentFilter = 'all'.obs; // all | unread | read
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  ValueListenable<Box<String>>? _listenable;
  VoidCallback? _listenerDispose;
  final NotificationRepository _repo = Get.find<NotificationRepository>();
  final RxBool loading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _attachListenable();
    fetchFromApi();
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
    await _repo.markAsRead(id);
    _load();
  }

  Future<void> markAllAsRead() async {
    await _repo.markAllAsRead();
    _load();
  }

  Future<void> delete(String id) async {
    await _repo.deleteNotification(id);
    _load();
  }

  Future<void> refreshList() async {
    await fetchFromApi();
  }

  int unreadCount() => NotificationStorageService.unreadCount();

  @override
  void onClose() {
    _listenerDispose?.call();
    super.onClose();
  }

  Future<void> fetchFromApi() async {
    loading.value = true;
    error.value = '';
    try {
      final list = await _repo.getNotifications();
      // Persist to local storage (upsert by id)
      for (final n in list) {
        await NotificationStorageService.save(n);
      }
    } catch (e) {
      error.value = 'Failed to fetch notifications';
    } finally {
      loading.value = false;
      _load();
    }
  }
}
