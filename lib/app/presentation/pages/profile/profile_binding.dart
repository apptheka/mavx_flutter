import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';

class ProfileBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(()=> ProfileController());
  }
}