import 'package:mavx_flutter/app/data/models/bookmarks_model.dart';
import 'package:mavx_flutter/app/domain/repositories/bookmarks_repository.dart';

class GetAllBookmarksUseCase {
  final BookmarkRepository _repo;
  GetAllBookmarksUseCase(this._repo);

  Future<BookmarksResponseModel> call(int userId) {
    return _repo.getAllBookmarks(userId);
  }
}
