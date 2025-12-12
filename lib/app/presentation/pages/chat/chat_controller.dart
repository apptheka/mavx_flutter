import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/services/chat_service.dart';
import 'package:mavx_flutter/app/core/services/storage_service.dart';

class ChatController extends GetxController {
  final ChatService _chatService;
  ChatController({ChatService? chatService}) : _chatService = chatService ?? ChatService();

  final TextEditingController inputController = TextEditingController();

  // IDs
  final String adminId = 'admin1';
  String? expertId;
  String get chatId => '${adminId}_${expertId ?? ''}';

  // State
  final RxList<_Msg> messages = <_Msg>[].obs;
  StreamSubscription<List<QueryDocumentSnapshot<Map<String, dynamic>>>>? _sub;

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    try {
      final storage = Get.find<StorageService>();
      final userJson = storage.prefs.getString(AppConstants.userKey);
      if (userJson != null && userJson.isNotEmpty) {
        final decoded = jsonDecode(userJson);
        if (decoded is Map<String, dynamic>) {
          // user may have been saved as full UserModel.data
          if (decoded.containsKey('data')) {
            final data = decoded['data'] as Map<String, dynamic>;
            expertId = data['id']?.toString();
          } else {
            expertId = decoded['id']?.toString();
          }
        }
      }
    } catch (_) {}
  }

  void startListening() {
    if (expertId == null || expertId!.isEmpty) return;
    _sub?.cancel();
    _sub = _chatService.messagesStream(chatId).listen((docs) {
      final list = docs.map((d) {
        final data = d.data();
        final sender = (data['sender'] ?? '').toString();
        final senderId = (data['senderId'] ?? '').toString();
        final from = sender == 'expert' && senderId == (expertId ?? '') ? MsgFrom.me : MsgFrom.other;
        final ts = data['createdAt'];
        DateTime date;
        if (ts is Timestamp) {
          date = ts.toDate();
        } else {
          date = DateTime.now();
        }
        return _Msg(id: d.id, from: from, text: (data['text'] ?? '').toString(), time: date);
      }).toList();
      messages.assignAll(list);
    });
  }

  Future<void> send() async {
    final txt = inputController.text.trim();
    if (txt.isEmpty || expertId == null || expertId!.isEmpty) return;
    try {
      await _chatService.addMessage(
        chatId,
        text: txt,
        sender: 'expert',
        senderId: expertId,
      );
      print('expertId: $expertId');
      inputController.clear();
    } catch (e) {
      final ctx = Get.context;
      if (ctx != null) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    startListening();
  }

  @override
  void onClose() {
    _sub?.cancel();
    inputController.dispose();
    super.onClose();
  }
}

enum MsgFrom { me, other }

class _Msg {
  final String id;
  final MsgFrom from;
  final String text;
  final DateTime time;
  _Msg({required this.id, required this.from, required this.text, required this.time});
}
