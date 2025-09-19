import 'package:get/get.dart';
import 'package:mavx_flutter/app/data/models/bookmarks_model.dart';
import 'package:mavx_flutter/app/data/models/projects_model.dart'; 
import 'package:mavx_flutter/app/domain/usecases/bookmark_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/delete_bookmark_usecase.dart'; 
import 'package:mavx_flutter/app/domain/usecases/projects_usecase.dart';
import 'package:mavx_flutter/app/domain/repositories/apply_job_repository.dart';

class ProjectDetailController extends GetxController {
  final ProjectsUseCase projectsUseCase = Get.find<ProjectsUseCase>();
  final BookmarkUseCase bookmarkUseCase = Get.find<BookmarkUseCase>();
  final DeleteBookmarkUseCase deleteBookmarkUseCase = Get.find<DeleteBookmarkUseCase>();
  final ApplyJobRepository applyJobRepository = Get.find<ApplyJobRepository>();

  final RxBool isLoadingBookmarked = false.obs;
  final RxBool isErrorBookmarked = false.obs;

  final RxList<ProjectModel> similarProjects = <ProjectModel>[].obs;
  final RxList<ProjectModel> project = <ProjectModel>[].obs;
  final RxList<Project> bookmarkedProjects = <Project>[].obs;
  final RxSet<int> bookmarkedIds = <int>{}.obs;
  final RxSet<int> appliedIds = <int>{}.obs;
  final RxBool loading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final int id = Get.arguments is int ? Get.arguments as int : 0;
    fetchProjectById(id).then((_) async {
      // Load applied IDs to reflect applied state
      try {
        final ids = await applyJobRepository.getAppliedProjectIdsForCurrentUser();
        appliedIds
          ..clear()
          ..addAll(ids);
      } catch (_) {}
      final currentType = _currentProjectType();
      fetchSimilarProjects(projectType: currentType);
    });
  }


  Future<void> fetchProjectById(int id) async {
    loading.value = true;
    error.value = '';
    try {
      final response = await projectsUseCase.projectById(id);
      project.value = response.data?.data ?? [];
    } catch (_) {
      error.value = 'Failed to load project';
    } finally {
      loading.value = false;
    }
  }

  String _currentProjectType() {
    try {
      if (project.isNotEmpty) {
        // ProjectModel is expected to expose projectType
        return project.first.projectType ?? '';
      }
    } catch (_) {}
    return '';
  }

  Future<void> toggleBookmark(int projectId) async {
    final isBookmarked = bookmarkedIds.contains(projectId);
    // Optimistic UI
    if (isBookmarked) {
      bookmarkedIds.remove(projectId);
    } else {
      bookmarkedIds.add(projectId);
    }
    try {
      isLoadingBookmarked.value = true;
      isErrorBookmarked.value = false;
      if (isBookmarked) {
        await deleteBookmarkUseCase.call(projectId);
        Get.snackbar('Removed', 'Bookmark removed');
      } else {
        final resp = await bookmarkUseCase.call(projectId);
        bookmarkedProjects.value = resp.projects ?? [];
        Get.snackbar('Saved', 'Job bookmarked');
      }
    } catch (_) {
      // Revert optimistic update
      if (isBookmarked) {
        bookmarkedIds.add(projectId);
      } else {
        bookmarkedIds.remove(projectId);
      }
      isErrorBookmarked.value = true;
      Get.snackbar('Error', 'Failed to update bookmark');
    } finally {
      isLoadingBookmarked.value = false;
    }
  }

  Future<void> fetchSimilarProjects({String projectType = ''}) async {
    loading.value = true;
    error.value = '';
    try {
      final data = await projectsUseCase.projects();
      final all = data.data?.data ?? <ProjectModel>[];
      final currentId = project.isNotEmpty ? project.first.id : null;
      List<ProjectModel> filtered;
      if (projectType.trim().isEmpty) {
        // Fallback: show other projects excluding current
        filtered = all.where((p) => p.id != currentId).toList();
      } else {
        filtered = all.where((p) =>
          (p.projectType ?? '').toLowerCase() == projectType.toLowerCase() &&
          p.id != currentId
        ).toList();
        // If none found for the same type, fall back to others excluding current
        if (filtered.isEmpty) {
          filtered = all.where((p) => p.id != currentId).toList();
        }
      }
      // Optional: cap the number shown
      if (filtered.length > 10) {
        filtered = filtered.take(10).toList();
      }
      similarProjects.value = filtered;
    } catch (_) {
      error.value = 'Failed to load similar projects';
    } finally {
      loading.value = false;
    }
  }
}