import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/services/chat_service.dart';
import 'package:mavx_flutter/app/data/repositories/profile_repository_impl.dart';
import 'package:mavx_flutter/app/domain/repositories/auth_repository.dart';
import 'package:mavx_flutter/app/core/services/storage_service.dart';
import 'package:mavx_flutter/app/domain/usecases/email_usecase.dart';
import 'package:mavx_flutter/app/presentation/pages/chat/chat_badge_controller.dart';

class ChatController extends GetxController {
  final ChatService _chatService;
  ChatController({ChatService? chatService})
      : _chatService = chatService ?? ChatService();

  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController(); // ✅ ADDED

  final AuthRepository authRepository = Get.find<AuthRepository>();

  // IDs
  final ProfileRepositoryImpl profileRepository =
      Get.find<ProfileRepositoryImpl>();
  String? expertId;
  final String adminId = 'admin1';
  String get chatId => expertId != null ? '${adminId}_${expertId}' : '';

  // State
  final RxList<_Msg> messages = <_Msg>[].obs;
  StreamSubscription<List<QueryDocumentSnapshot<Map<String, dynamic>>>>? _sub;
  Timer? _noReplyTimer;
  DateTime? _lastExpertMessageAt;
  DateTime? _nextAllowedEmailAt;
  

  @override
  void onInit() {
    super.onInit();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    expertId = await profileRepository.currentUserId();
    print("chatId>>>>>>>>>>$chatId");
    if (chatId.isNotEmpty) {
      startListening();
    }
  }

  void startListening() {
    
    if (chatId.isEmpty) return;
    print("chatId>>>>>>>>>>$chatId");

    _sub?.cancel();
    _sub = _chatService.messagesStream(chatId).listen((docs) {
      final list = docs.map((d) {
        final data = d.data();
        final sender = (data['sender'] ?? '').toString();
        final senderId = (data['senderId'] ?? '').toString(); 

        final from =
            sender == 'expert' && senderId == expertId
                ? MsgFrom.me
                : MsgFrom.other;

        final ts = data['createdAt'];
         
        final date =
            ts is Timestamp ? ts.toDate() : DateTime.now();

        return _Msg(
          id: d.id,
          from: from,
          text: (data['text'] ?? '').toString(),
          time: date,
        );
      }).toList();

      messages.assignAll(list);
      _handleAdminReplySinceLastExpert(list);
      _scrollToBottom();
    });

    _markSeenNow();
  }

  Future<void> send() async {
    final txt = inputController.text.trim();
    if (txt.isEmpty || chatId.isEmpty) return;

    try {
      await ensureChatExists();
      await _chatService.addMessage(
        chatId,
        text: txt,
        sender: 'expert',
        senderId: expertId,
      );

      _maybeSendImmediateEmail(txt);
      _lastExpertMessageAt = DateTime.now();
      _scheduleNoReplyFollowUp();

      inputController.clear();
      _scrollToBottom(); // ✅ AUTO SCROLL
    } catch (e) {
      final ctx = Get.context;
      if (ctx != null) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          SnackBar(
            content: Text('Failed to send message: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> ensureChatExists() async {
    final ref =
        FirebaseFirestore.instance.collection('chats').doc(chatId);

    if (!(await ref.get()).exists) {
      await ref.set({
        'adminId': adminId,
        'expertId': expertId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// ✅ Scroll Helper
  void _scrollToBottom() {
    if (!scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

 @override
void onClose() {
  _sub?.cancel();
  inputController.dispose();
  scrollController.dispose();

  _markSeenNow();

  // 🔥 NOTIFY HOME BADGE
  Get.find<ChatBadgeController>().refresh();

  _noReplyTimer?.cancel();
  super.onClose();
}


  void _markSeenNow() {
    try {
      if (chatId.isEmpty) return;
      final prefs = Get.find<StorageService>().prefs;
      prefs.setInt(
        'chat_last_seen_$chatId',
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (_) {}
  }

  void _handleAdminReplySinceLastExpert(List<_Msg> list) {
    if (_lastExpertMessageAt == null) return;
    final replied = list.any(
      (m) =>
          m.from == MsgFrom.other &&
          m.time.isAfter(_lastExpertMessageAt!),
    );
    if (replied) {
      _noReplyTimer?.cancel();
      _noReplyTimer = null;
    }
  }

  void _scheduleNoReplyFollowUp() {
    _noReplyTimer?.cancel();
    _noReplyTimer =
        Timer.periodic(const Duration(minutes: 10), (_) {
      if (_lastExpertMessageAt == null) return;
      final hasReply = messages.any(
        (m) =>
            m.from == MsgFrom.other &&
            m.time.isAfter(_lastExpertMessageAt!),
      );
      if (!hasReply) {
        _sendEmailNotification(
            'No reply within 10 minutes for chat $chatId');
      } else {
        _noReplyTimer?.cancel();
        _noReplyTimer = null;
      }
    });
  }

  Future<void> _sendEmailNotification(String content) async {
    try {
      final sendEmail = Get.find<SendEmailUseCase>();
      await sendEmail(
        to: 'mavxpanel@gmail.com',
        subject: 'New chat message from expert $expertId',
        type: 'text',
        content: content,
      );
      final now = DateTime.now();
      // Extend global cooldown window so subsequent messages within 10 minutes don't re-trigger
      _nextAllowedEmailAt = now.add(const Duration(minutes: 10));
    } catch (_) {}
  }

  void _maybeSendImmediateEmail(String content) {
    final now = DateTime.now();
    // Hard throttle: do not send if within the 10-minute cooldown window
    if (_nextAllowedEmailAt != null && now.isBefore(_nextAllowedEmailAt!)) {
      return;
    }
    // Set next allowed time immediately to avoid race when user sends multiple messages quickly
    _nextAllowedEmailAt = now.add(const Duration(minutes: 10));
    _sendEmailNotification(content);
  }
}

enum MsgFrom { me, other }

class _Msg {
  final String id;
  final MsgFrom from;
  final String text;
  final DateTime time;

  _Msg({
    required this.id,
    required this.from,
    required this.text,
    required this.time,
  });
}
