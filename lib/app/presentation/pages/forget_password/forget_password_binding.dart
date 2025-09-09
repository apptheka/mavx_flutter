import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/forget_password/forget_password_controller.dart';

class ForgetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ForgetPasswordController>(ForgetPasswordController());
  }
}