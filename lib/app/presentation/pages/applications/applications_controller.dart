import 'package:get/get.dart';
import 'package:mavx_flutter/app/data/models/projects_model.dart';
import 'package:mavx_flutter/app/domain/repositories/apply_job_repository.dart';

class ApplicationsController extends GetxController {
  ApplicationsController({ApplyJobRepository? repo})
      : _repo = repo ?? Get.find<ApplyJobRepository>();

  final ApplyJobRepository _repo;

  final RxBool loading = false.obs;
  final RxString error = ''.obs;
  final RxList<ProjectModel> projects = <ProjectModel>[].obs;
  final RxSet<int> appliedIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    loading.value = true;
    error.value = '';
    try {
      final ids = await _repo.getAppliedProjectIdsForCurrentUser();
      appliedIds
        ..clear()
        ..addAll(ids);
      final list = await _repo.getAppliedProjectsForCurrentUser();
      projects.assignAll(list);
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }
}
