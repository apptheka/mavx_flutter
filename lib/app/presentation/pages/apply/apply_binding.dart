import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/apply/apply_controller.dart';

class ApplyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApplyController());
  }
}