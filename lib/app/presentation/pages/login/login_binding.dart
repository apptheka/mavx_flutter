import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/login/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
  }
}