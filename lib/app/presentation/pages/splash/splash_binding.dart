import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/splash/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}