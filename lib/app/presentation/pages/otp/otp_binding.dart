  import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/otp/otp_controller.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<OtpController>(OtpController());
  }
}