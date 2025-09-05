import 'package:get/get.dart';
import 'package:mavx_flutter/app/data/models/projects_model.dart';
import 'package:mavx_flutter/app/domain/usecases/projects_usecase.dart';
import 'package:flutter/widgets.dart';

class SearchController extends GetxController {
  final ProjectsUseCase projectsUseCase = Get.find<ProjectsUseCase>();
  final isLoading = false.obs; // loading for search
  final isLoadingMore = false.obs; // reserved for future pagination
  final isError = false.obs;
  final RxList<ProjectModel> jobs = <ProjectModel>[].obs;
  // Query text
  final query = ''.obs;

  // Work type filters similar to LinkedIn: Remote, Hybrid, On Site
  final availableWorkTypes = const ['Remote', 'Hybrid', 'On Site'];
  final selectedWorkTypes = <String>{}.obs; // empty -> all

  // Derived filtered list
  late final RxList<ProjectModel> filteredJobs;

  // Reserved for future pagination if backend supports it on search
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    filteredJobs = <ProjectModel>[].obs;
    // Debounce query and trigger server-side search
    debounce(query, (_) => _performSearch(), time: const Duration(milliseconds: 400));
    // React to filter changes and re-search
    ever(selectedWorkTypes, (_) => _performSearch());
    // Initial load: show all projects by default
    _performSearch();
  }

  void toggleWorkType(String type) {
    if (selectedWorkTypes.contains(type)) {
      selectedWorkTypes.remove(type);
    } else {
      selectedWorkTypes.add(type);
    }
  }

  void setQuery(String value) {
    query.value = value;
  }

  void clearFilters() {
    selectedWorkTypes.clear();
  }

  // Map local work type label to backend 'type' query
  String _mapTypeForApi() {
    if (selectedWorkTypes.isEmpty) return '';
    // If multiple selected, pass the first (or adapt if API supports comma separated)
    final first = selectedWorkTypes.first.toLowerCase();
    // Normalize to API expectations if needed
    // Example mapping can be adjusted as backend requires
    if (first.contains('remote')) return 'Remote';
    if (first.contains('hybrid')) return 'Hybrid';
    if (first.contains('on site') || first.contains('onsite')) return 'On Site';
    return '';
  }

  Future<void> _performSearch() async {
    try {
      final q = query.value.trim();
      isLoading.value = true;
      isError.value = false;
      final resp = (q.isEmpty && selectedWorkTypes.isEmpty)
          // No query or filters -> load all projects
          ? await projectsUseCase.projects()
          // Otherwise do server-side search
          : await projectsUseCase.search(
              search: q,
              type: _mapTypeForApi(),
              industry: '',
            );
      final results = resp.data ?? <ProjectModel>[];
      jobs.assignAll(results);
      filteredJobs.assignAll(results);
    } catch (e) {
      isError.value = true;
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
