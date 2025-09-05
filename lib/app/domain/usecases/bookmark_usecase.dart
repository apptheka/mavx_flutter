import 'package:mavx_flutter/app/data/models/bookmarks_model.dart';
import 'package:mavx_flutter/app/domain/repositories/bookmarks_repository.dart';

class BookmarkUseCase {
  final BookmarkRepository _bookmarkRepository;

  BookmarkUseCase(this._bookmarkRepository);

  Future<BookmarksResponseModel> call(int projectId) {
    return _bookmarkRepository.getBookmarks(projectId);
  }
}