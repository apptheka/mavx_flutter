import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/my_projects/my_projects_controller.dart';

class MyProjectsBinding extends Bindings{
  @override
  void dependencies() { 
     Get.lazyPut(()=> MyProjectsController());
  }

}