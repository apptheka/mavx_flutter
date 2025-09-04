import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/project_detail/project_detail_controller.dart';

class ProjectDetailBinding extends Bindings {
@override
  void dependencies() {
    Get.put(ProjectDetailController());
  }

}