import 'package:get/get.dart';

class ChatBadgeController extends GetxController {
  final RxInt refreshTick = 0.obs;

  void refresh() {
    refreshTick.value++;
  }
}
