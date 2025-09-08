import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/requests/requests_controller.dart';

class RequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RequestsController());
  }
}