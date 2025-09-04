import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/search/search_controller.dart' as search;

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<search.SearchController>(search.SearchController());
  }
}
