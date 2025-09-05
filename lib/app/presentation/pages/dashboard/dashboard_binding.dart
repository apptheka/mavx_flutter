import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/home/home_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    // Provide HomeController since HomePage is used inside Dashboard without its own route binding
    Get.put(HomeController());
    // Provide ProfileController because ProfilePage is used inside Dashboard without its route binding
    Get.put(ProfileController());
  }
}