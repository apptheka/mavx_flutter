import 'package:get/get.dart';
import 'package:mavx_flutter/app/data/models/bookmarks_model.dart' as bm;
import 'package:mavx_flutter/app/domain/repositories/auth_repository.dart';
import 'package:mavx_flutter/app/domain/usecases/get_all_bookmarks_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/delete_bookmark_usecase.dart';
import 'package:mavx_flutter/app/domain/repositories/apply_job_repository.dart';

class SavedController extends GetxController {
  SavedController({
    GetAllBookmarksUseCase? getAllBookmarksUseCase,
    AuthRepository? authRepository,
    DeleteBookmarkUseCase? deleteBookmarkUseCase,
    ApplyJobRepository? applyRepo,
  }) : _getAllBookmarksUseCase =
           getAllBookmarksUseCase ?? Get.find<GetAllBookmarksUseCase>(),
       _authRepository = authRepository ?? Get.find<AuthRepository>(),
       _deleteBookmarkUseCase = deleteBookmarkUseCase ?? Get.find<DeleteBookmarkUseCase>(),
       _applyRepo = applyRepo ?? Get.find<ApplyJobRepository>();

  final GetAllBookmarksUseCase _getAllBookmarksUseCase;
  final AuthRepository _authRepository;
  final DeleteBookmarkUseCase _deleteBookmarkUseCase;
  final ApplyJobRepository _applyRepo;

  final RxBool loading = false.obs;
  final RxString error = ''.obs;
  final RxList<bm.Project> saved = <bm.Project>[].obs;
  final RxInt total = 0.obs;
  final RxSet<int> appliedIds = <int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSaved();
  }
 
  Future<void> fetchSaved() async {
    loading.value = true;
    error.value = '';
    try {
      final currentUser = await _authRepository.getCurrentUser();
      final uid = currentUser?.data.id;
      if (uid == null) {
        saved.clear();
        total.value = 0;
      } else {
        final resp = await _getAllBookmarksUseCase.call(uid);
        saved.assignAll(resp.projects ?? []);
        total.value = resp.total ?? saved.length;
        // Remove any projects that are already applied
        try {
          final ids = await _applyRepo.getAppliedProjectIdsForCurrentUser();
          appliedIds
            ..clear()
            ..addAll(ids);
          saved.removeWhere((p) => p.id != null && appliedIds.contains(p.id!));
          total.value = saved.length;
        } catch (_) {
          // ignore filtering on failure
        }
      }
    } catch (e) {
      error.value = 'Failed to load saved projects\nConnection Error';
    } finally {
      loading.value = false;
    }
  }

  Future<void> removeBookmark(int bookmarkId) async {
    // Optimistic update
    final previous = List<bm.Project>.from(saved);
    saved.removeWhere((project) => project.id == bookmarkId);
    total.value = saved.length;
    try {
      await _deleteBookmarkUseCase.call(bookmarkId);
      // Immediately refresh from server to reflect true state
     refresh();
    } catch (e) {
      // Revert on failure and surface error
      saved.assignAll(previous);
      total.value = saved.length;
      error.value = 'Failed to remove bookmark';
    }
  }

  Future<void> refresh() async {
    await fetchSaved();
  }
}
