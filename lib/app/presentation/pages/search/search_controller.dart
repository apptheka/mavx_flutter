import 'package:get/get.dart';
import 'package:mavx_flutter/app/data/models/projects_model.dart';
import 'package:mavx_flutter/app/domain/usecases/projects_usecase.dart';
import 'package:flutter/widgets.dart';
import 'package:mavx_flutter/app/domain/usecases/get_all_industries_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/get_all_specification_usecase.dart';
import 'package:mavx_flutter/app/data/models/industries_model.dart';
import 'package:mavx_flutter/app/data/models/specifications_model.dart';
import 'package:mavx_flutter/app/domain/repositories/apply_job_repository.dart';

class SearchController extends GetxController {
  final ProjectsUseCase projectsUseCase = Get.find<ProjectsUseCase>();
  final ApplyJobRepository _applyRepo = Get.find<ApplyJobRepository>();
  final GetAllIndustriesUseCase _industriesUseCase = Get.find<GetAllIndustriesUseCase>();
  final GetAllSpecificationUseCase _specUseCase = Get.find<GetAllSpecificationUseCase>();
  final isLoading = false.obs; // loading for search
  final isLoadingMore = false.obs; // reserved for future pagination
  final isError = false.obs;
  final RxList<ProjectModel> jobs = <ProjectModel>[].obs;
  // Query text
  final query = ''.obs;

  // Work type filters similar to LinkedIn: Remote, Hybrid, On Site
  final availableWorkTypes = const ['Remote', 'Hybrid', 'On Site'];
  // Staged (in-bottom-sheet) and applied selections
  final stagedWorkTypes = <String>{}.obs; // user toggles here
  final appliedWorkTypes = <String>{}.obs; // actually used in search

  // Derived filtered list
  late final RxList<ProjectModel> filteredJobs;

  // Reserved for future pagination if backend supports it on search
  final ScrollController scrollController = ScrollController();

  // Left pane selection: 0 -> Project Type, 1 -> Industry
  final leftMenuIndex = 0.obs;

  // Data sources for filters
  final RxList<JobRole> projectTypes = <JobRole>[].obs;
  final RxList<Industry> industries = <Industry>[].obs;
  final filtersLoading = false.obs;

  // Current selections (multi-select; staged and applied)
  final RxSet<int> stagedProjectTypeIds = <int>{}.obs;
  final RxSet<int> stagedIndustryIds = <int>{}.obs;
  final RxSet<int> appliedProjectTypeIds = <int>{}.obs;
  final RxSet<int> appliedIndustryIds = <int>{}.obs;
  final RxSet<int> appliedIds = <int>{}.obs; // projects already applied by user

  @override
  void onInit() {
    super.onInit();
    filteredJobs = <ProjectModel>[].obs;
    // Debounce query and trigger server-side search
    debounce(query, (_) => _performSearch(), time: const Duration(milliseconds: 400));
    // Do not react to staged changes; only apply on button.
    // Initial load: show all projects by default
    _performSearch();
    _loadFilters();
    refreshAppliedIds();
  }

  void toggleWorkType(String type) {
    if (stagedWorkTypes.contains(type)) {
      stagedWorkTypes.remove(type);
    } else {
      stagedWorkTypes.add(type);
    }
  }

  void setQuery(String value) {
    query.value = value;
  }

  void clearFilters() {
    // Clear both staged and applied and then re-search
    stagedWorkTypes.clear();
    appliedWorkTypes.clear();
    stagedProjectTypeIds.clear();
    stagedIndustryIds.clear();
    appliedProjectTypeIds.clear();
    appliedIndustryIds.clear();
    _performSearch();
  }

  // Map local work type label to backend 'type' query
  String _mapTypeForApi() {
    if (appliedWorkTypes.isEmpty) return '';
    // If multiple selected, pass the first (or adapt if API supports comma separated)
    final first = appliedWorkTypes.first.toLowerCase();
    // Normalize to API expectations if needed
    // Example mapping can be adjusted as backend requires
    if (first.contains('remote')) return 'Remote';
    if (first.contains('hybrid')) return 'Hybrid';
    if (first.contains('on site') || first.contains('onsite')) return 'On Site';
    return '';
  }

  void toggleProjectType(int id) {
    if (stagedProjectTypeIds.contains(id)) {
      stagedProjectTypeIds.remove(id);
    } else {
      stagedProjectTypeIds.add(id);
    }
    stagedProjectTypeIds.refresh();
  }

  void toggleIndustry(int id) {
    if (stagedIndustryIds.contains(id)) {
      stagedIndustryIds.remove(id);
    } else {
      stagedIndustryIds.add(id);
    }
    stagedIndustryIds.refresh();
  }

  void startStaging() {
    // Copy applied into staged when opening bottom sheet
    stagedWorkTypes
      ..clear()
      ..addAll(appliedWorkTypes);
    stagedProjectTypeIds
      ..clear()
      ..addAll(appliedProjectTypeIds);
    stagedIndustryIds
      ..clear()
      ..addAll(appliedIndustryIds);
  }

  void applyStagedFilters() {
    appliedWorkTypes
      ..clear()
      ..addAll(stagedWorkTypes);
    appliedProjectTypeIds
      ..clear()
      ..addAll(stagedProjectTypeIds);
    appliedIndustryIds
      ..clear()
      ..addAll(stagedIndustryIds);
    _performSearch();
  }

  Future<void> _loadFilters() async {
    try {
      filtersLoading.value = true;
      final indResp = await _industriesUseCase();
      industries.assignAll(indResp.data.data);
      final specResp = await _specUseCase();
      projectTypes.assignAll(specResp.data.data);
    } catch (e) {
      // swallow silently; UI can show empty lists
    } finally {
      filtersLoading.value = false;
    }
  }

  Future<void> refreshAppliedIds() async {
    try {
      final ids = await _applyRepo.getAppliedProjectIdsForCurrentUser();
      appliedIds
        ..clear()
        ..addAll(ids);
    } catch (_) {
      // ignore errors fetching applied IDs for search
    }
  }

  Future<void> _performSearch() async {
    try {
      final q = query.value.trim();
      isLoading.value = true;
      isError.value = false;
      final hasType = appliedWorkTypes.isNotEmpty; // work type
      final hasSpec = appliedProjectTypeIds.isNotEmpty; // project types (specialisation)
      final hasIndustry = appliedIndustryIds.isNotEmpty;
      // Build comma-separated titles from applied ids
      String _typesAsString() {
        // Only work type goes in 'type'
        return _mapTypeForApi();
      }
      String _specAsString() {
        return projectTypes
            .where((e) => appliedProjectTypeIds.contains(e.id))
            .map((e) => e.id.toString())
            .join(',');
      }
      String _industriesAsString() {
        return industries
            .where((e) => appliedIndustryIds.contains(e.id))
            .map((e) => e.id.toString())
            .join(',');
      }
      final resp = (q.isEmpty && !hasType && !hasSpec && !hasIndustry)
          // No query or filters -> load all projects
          ? await projectsUseCase.projects()
          // Otherwise do server-side search
          : await projectsUseCase.search(
              search: q,
              type: hasType ? _typesAsString() : '',
              industry: hasIndustry ? _industriesAsString() : '',
              specialisation: hasSpec ? _specAsString() : '',
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
