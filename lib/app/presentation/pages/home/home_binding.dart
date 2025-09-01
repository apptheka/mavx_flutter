import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/home/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}