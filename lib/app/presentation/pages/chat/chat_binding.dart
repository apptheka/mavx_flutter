import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/chat/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatController(), fenix: true);
  }
}