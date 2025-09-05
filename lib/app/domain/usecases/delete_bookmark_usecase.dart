import 'package:mavx_flutter/app/domain/repositories/bookmarks_repository.dart';

class DeleteBookmarkUseCase {
  final BookmarkRepository _repo;
  DeleteBookmarkUseCase(this._repo);

  Future<void> call(int projectId) {
    return _repo.deleteBookmark(projectId);
  }
}
