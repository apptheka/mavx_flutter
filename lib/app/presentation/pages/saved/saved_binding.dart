import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/saved/saved_controller.dart';

class SavedBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SavedController());
  }
}
