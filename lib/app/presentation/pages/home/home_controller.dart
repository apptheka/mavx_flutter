import 'package:get/get.dart';
import 'package:mavx_flutter/app/data/models/bookmarks_model.dart';
import 'package:mavx_flutter/app/domain/repositories/auth_repository.dart';
import 'package:mavx_flutter/app/data/models/user_model.dart';
import 'package:mavx_flutter/app/data/models/projects_model.dart';
import 'package:mavx_flutter/app/domain/usecases/bookmark_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/delete_bookmark_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/get_all_bookmarks_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/projects_usecase.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/domain/repositories/apply_job_repository.dart';

class HomeController extends GetxController {
  HomeController({
    AuthRepository? authRepository,
    ProjectsUseCase? projectsUseCase,
    BookmarkUseCase? bookmarkUseCase,
    DeleteBookmarkUseCase? deleteBookmarkUseCase,
    GetAllBookmarksUseCase? getAllBookmarksUseCase,
    ApplyJobRepository? applyJobRepository,
  }) : _authRepository = authRepository ?? Get.find<AuthRepository>(),
       _projectsUseCase = projectsUseCase ?? Get.find<ProjectsUseCase>(),
       _bookmarkUseCase = bookmarkUseCase ?? Get.find<BookmarkUseCase>(),
       _deleteBookmarkUseCase = deleteBookmarkUseCase ?? Get.find<DeleteBookmarkUseCase>(),
       _getAllBookmarksUseCase = getAllBookmarksUseCase ?? Get.find<GetAllBookmarksUseCase>(),
       _applyRepo = applyJobRepository ?? Get.find<ApplyJobRepository>();

  final AuthRepository _authRepository;
  final ProjectsUseCase _projectsUseCase;
  final BookmarkUseCase _bookmarkUseCase;
  final DeleteBookmarkUseCase _deleteBookmarkUseCase;
  final GetAllBookmarksUseCase _getAllBookmarksUseCase;
  final ApplyJobRepository _applyRepo;

  // Reactive user data for header
  final RxBool isLoadingBookmarks = false.obs;
  final RxBool isErrorBookmarks = false.obs;
  final Rxn<UserData> user = Rxn<UserData>(); 
  final RxList<Project> bookmarks = <Project>[].obs;
  final RxSet<int> bookmarkedIds = <int>{}.obs;
  final RxInt totalBookmarks = 0.obs;
  final RxString greeting = ''.obs;
  final RxBool isLoadingProjects = false.obs;
  // Fine-grained refresh flags per section
  final RxBool isRefreshingTopMatches = false.obs;
  final RxBool isRefreshingOtherProjects = false.obs;
  final RxList<ProjectModel> allProjects = <ProjectModel>[].obs;
  final RxList<ProjectModel> topMatches = <ProjectModel>[].obs;
  final RxList<ProjectModel> otherProjects = <ProjectModel>[].obs;
  final RxList<ProjectModel> filteredProjects = <ProjectModel>[].obs;
  final RxInt selectedFilter =
      0.obs; // 0: All, 1: On Site, 2: Remote, 3: Hybrid
  final RxSet<int> appliedIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _computeGreeting();
    loadUser();
    fetchProjects();
    _initBookmarks();
    refreshAppliedIds();
  }

  Future<void> refreshAppliedIds() async {
    try {
      final ids = await _applyRepo.getAppliedProjectIdsForCurrentUser();
      appliedIds
        ..clear()
        ..addAll(ids);
    } catch (_) {
      // ignore errors
    }
  }

  Future<void> _initBookmarks() async {
    try {
      final currentUser = await _authRepository.getCurrentUser();
      final uid = currentUser?.data.id;
      if (uid == null) return;
      final resp = await _getAllBookmarksUseCase.call(uid);
      bookmarks.value = resp.projects ?? [];
      totalBookmarks.value = resp.total ?? 0;
      // populate set of bookmarked project ids
      bookmarkedIds
        ..clear()
        ..addAll((resp.projects ?? []).map((p) => p.id).whereType<int>());
    } catch (_) {
      // ignore init errors
    }
  }

  // Fetch projects from API then compute matches
  Future<void> fetchProjects({bool showGlobalLoader = true}) async {
    try {
      if (showGlobalLoader) isLoadingProjects.value = true;
      final resp = await _projectsUseCase.projects();
      final list = resp.data ?? [];
      allProjects.assignAll(list);
      _recomputeMatches();
      applyFilter(selectedFilter.value);
    } catch (_) {
      // Optionally expose an error state
    }
    finally {
      if (showGlobalLoader) isLoadingProjects.value = false;
    }
  }

Future<void> refreshTopMatches() async {
  isRefreshingTopMatches.value = true;
  try {
    // Fetch fresh projects but only recompute topMatches, keep otherProjects as-is
    final resp = await _projectsUseCase.projects();
    final list = resp.data ?? [];

    final profileController = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : null;
    final roleType = profileController?.registeredProfile.value.roleType?.trim();
    final primarySector = profileController?.registeredProfile.value.primarySector;

    final filtered = list.where((p) {
      final pType = (p.projectType ?? '');
      final matchRole = (roleType == null || roleType.isEmpty) || (pType.isNotEmpty && pType == roleType);
      final matchSector = (primarySector == null) || (p.industry != null && p.industry == primarySector);
      return matchRole && matchSector;
    }).toList();

    topMatches.assignAll(filtered);
  } finally {
    isRefreshingTopMatches.value = false;
  }
}

  Future<void> refreshOtherOnly() async {
    isRefreshingOtherProjects.value = true;
    try {
      await fetchProjects(showGlobalLoader: false);
    } finally {
      isRefreshingOtherProjects.value = false;
    }
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
      isLoadingBookmarks.value = true;
      isErrorBookmarks.value = false;
      if (isBookmarked) {
        await _deleteBookmarkUseCase.call(projectId);
        totalBookmarks.value = (totalBookmarks.value - 1).clamp(0, 1 << 30);
        // Keep local bookmarks list in sync
        bookmarks.removeWhere((p) => p.id == projectId);
      } else {
        final resp = await _bookmarkUseCase.call(projectId);
        bookmarks.value = resp.projects ?? [];
        totalBookmarks.value = resp.total ?? (totalBookmarks.value + 1);
      }
    } catch (_) {
      // Revert optimistic update
      if (isBookmarked) {
        bookmarkedIds.add(projectId);
      } else {
        bookmarkedIds.remove(projectId);
      }
      isErrorBookmarks.value = true;
      Get.snackbar('Error', 'Failed to update bookmark');
    } finally {
      isLoadingBookmarks.value = false;
    }
  }

  // Public helper for tag chip from a project
  String chipFor(ProjectModel p) {
    final t = (p.projectType ?? '').toLowerCase();
    if (t.contains('remote')) return 'Remote';
    if (t.contains('hybrid')) return 'Hybrid';
    return 'On Site';
  }

  void _recomputeMatches() {
    final profileController = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : null;
    final roleType = profileController?.registeredProfile.value.roleType
        ?.trim();
    final primarySector =
        profileController?.registeredProfile.value.primarySector; 
 
    final filtered = allProjects.where((p) {
      final pType = (p.projectType ?? '') ;

      final matchRole =
          (roleType == null || roleType.isEmpty) ||
          (pType.isNotEmpty && pType == roleType); 

          
      final matchSector =
          (primarySector == null) ||
          (p.industry != null && p.industry == primarySector);
      return matchRole && matchSector;
    }).toList();

    topMatches.assignAll(filtered);

    // Other projects are remaining ones; cap to 3 by default (filter can change)
    final remaining = allProjects
        .where((p) => !topMatches.contains(p))
        .toList();
    otherProjects.assignAll(remaining); 
  }

  // Apply chip filter to other projects and keep only 3 for display
  void applyFilter(int index) {
    selectedFilter.value = index;
    Iterable<ProjectModel> base = otherProjects;
    
    if (index == 0) {
      // Show all projects
      filteredProjects.assignAll(base.take(3).toList());
      return;
    }
    
    final filters = ['All', 'Consulting', 'Recruitment', 'Full Time', 'Contract Placement', 'Contract', 'Internal'];
    final filterType = filters[index];
    
    filteredProjects.assignAll(
      base.where((p) {
        final projectType = (p.projectType ?? '').trim().toLowerCase();
        switch (filterType) {
          case 'Consulting':
            return projectType.contains('consult');
          case 'Recruitment':
            return projectType.contains('recruit');
          case 'Full Time':
            return projectType == 'full_time' || projectType.contains('full');
          case 'Contract Placement':
            return projectType.contains('contract placement');
          case 'Contract':
            return projectType.contains('contract') && !projectType.contains('contract placement');
          case 'Internal':
            return projectType.contains('internal');
          default:
            return true;
        }
      }).take(3).toList(),
    );
  }

  Future<void> loadUser() async {
    try {
      final model = await _authRepository.getCurrentUser();
      user.value = model?.data;
    } catch (_) {
      // ignore error, keep null user
    }
  }

  void _computeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting.value = 'Good Morning';
    } else if (hour < 17) {
      greeting.value = 'Good Afternoon';
    } else {
      greeting.value = 'Good Evening';
    }
  }


  String? get avatarUrl {
    final p = user.value?.profile.trim();
    if (p == null || p.isEmpty) return null;
    final uri = Uri.tryParse(p);
    if (uri == null) return null;
    final scheme = uri.scheme ;
    if (scheme != 'http' && scheme != 'https') return null;
    return p;
  }

  void refreshPage(){
    fetchProjects();
    _initBookmarks();
    refreshAppliedIds();
  }
}
