import 'package:get/get.dart';
import 'package:mavx_flutter/app/data/models/projects_model.dart';
import 'package:mavx_flutter/app/domain/usecases/projects_usecase.dart';
import 'package:flutter/widgets.dart';

class SearchController extends GetxController {
  final ProjectsUseCase projectsUseCase = Get.find<ProjectsUseCase>();
  final isLoading = false.obs; // initial page loading
  final isLoadingMore = false.obs; // next pages loading
  final isError = false.obs;
  final RxList<ProjectModel> jobs = <ProjectModel>[].obs;
  // Query text
  final query = ''.obs;

  // Work type filters similar to LinkedIn: Remote, Hybrid, On Site
  final availableWorkTypes = const ['Remote', 'Hybrid', 'On Site'];
  final selectedWorkTypes = <String>{}.obs; // empty -> all

 

  // Derived filtered list
  late final RxList<ProjectModel> filteredJobs;

  // Pagination state
  final int limit = 10;
  int _page = 1;
  final hasMore = true.obs;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    filteredJobs = <ProjectModel>[].obs;
    // Attach scroll listener for infinite scroll
    scrollController.addListener(_onScroll);
    // Fetch first page
    fetchProjects(reset: true);

    // React to changes
    everAll([query, selectedWorkTypes], (_) => _recompute());
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

  void _recompute() {
    final q = query.value.trim().toLowerCase();
    final Set<String> activeTypes = selectedWorkTypes.toSet();
    // final Set<String> activeTypesNorm = activeTypes.map(_norm).toSet();

    final result = jobs.where((job) {
      // Backend doesn't provide a work type list yet; treat as pass-through unless user selected filters
      final matchesType = activeTypes.isEmpty;

      // Text query filter over title, company, location
      final title = (job.projectTitle ?? '').toLowerCase();
      final company = (job.projectType ?? '').toLowerCase();
      final location = (job.industry?.toString() ?? '').toLowerCase();

      final matchesQuery = q.isEmpty ||
          title.contains(q) ||
          company.contains(q) ||
          location.contains(q);

      return matchesType && matchesQuery;
    }).toList();

    filteredJobs.assignAll(result);
  }

  void _onScroll() {
    if (!hasMore.value || isLoadingMore.value || isLoading.value) return;
    if (!scrollController.hasClients) return;
    final threshold = 200.0; // px to start prefetching
    final maxScroll = scrollController.position.maxScrollExtent;
    final current = scrollController.position.pixels;
    if (maxScroll - current <= threshold) {
      fetchProjects();
    }
  }

  // Fetch projects (initial or next page)
  Future<void> fetchProjects({bool reset = false}) async {
    try {
      if (reset) {
        _page = 1;
        hasMore.value = true;
        jobs.clear();
        filteredJobs.clear();
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final resp = await projectsUseCase.projects(page: _page, limit: limit);
      final List<ProjectModel> incoming = resp.data ?? <ProjectModel>[];

      // Append results
      jobs.addAll(incoming);
      // Show unfiltered list by default (then reactive filters may reduce it)
      _recompute();

      // Determine if there are more pages
      if (incoming.length < limit) {
        hasMore.value = false;
      } else {
        _page += 1;
      }
    } catch (e) {
      isError.value = true;
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
