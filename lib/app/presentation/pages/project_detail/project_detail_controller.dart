import 'package:get/get.dart';
import 'package:mavx_flutter/app/data/models/similar_project_model.dart';
import 'package:mavx_flutter/app/domain/usecases/get_similar_projects_usecase.dart';

class ProjectDetailController extends GetxController {
  ProjectDetailController({GetSimilarProjectsUseCase? getSimilarProjectsUseCase})
      : _getSimilar = getSimilarProjectsUseCase ?? Get.find<GetSimilarProjectsUseCase>();

  final GetSimilarProjectsUseCase _getSimilar;

  final RxList<SimilarProject> similarProjects = <SimilarProject>[].obs;
  final RxBool loading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSimilarProjects();
  }

  Future<void> fetchSimilarProjects() async {
    loading.value = true;
    error.value = '';
    try {
      final data = await _getSimilar.getProjects();
      similarProjects.assignAll(data);
    } catch (_) {
      error.value = 'Failed to load similar projects';
    } finally {
      loading.value = false;
    }
  }
}