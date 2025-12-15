import 'package:get/get.dart';
import 'package:mavx_flutter/app/data/repositories/profile_repository_impl.dart';
import 'package:mavx_flutter/app/presentation/pages/chat/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileRepositoryImpl(), fenix: true);
    Get.lazyPut(() => ChatController(), fenix: true);
  }
}