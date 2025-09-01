import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/getStarted/get_started_controller.dart'; 

class GetStartedBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GetStartedController());
  }
}