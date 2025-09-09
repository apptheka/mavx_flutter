import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/change_password/change_pass_controller.dart';

class ChangePassBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ChangePassController>(ChangePassController());
  }
}