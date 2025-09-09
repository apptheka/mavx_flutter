import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/applications/applications_controller.dart';

class DashboardController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }


  void refreshPage(int index) {
  // Call specific refresh functions depending on page
  switch (index) {
    case 1:
      // Get.find<TrackerController>().refreshData(); // example
      break;
    case 2: 
      break;
    case 3:
      Get.find<ApplicationsController>().fetchData(); // example
      break;
    case 4:
      // Get.find<MenuController>().refreshMenu(); // example
      break;
  }
}
}