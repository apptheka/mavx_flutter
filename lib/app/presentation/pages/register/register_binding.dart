import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/register/controller/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RegisterController());
  }
}