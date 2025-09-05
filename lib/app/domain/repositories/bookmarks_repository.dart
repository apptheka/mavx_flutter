import 'package:mavx_flutter/app/data/models/bookmarks_model.dart';

abstract class BookmarkRepository {
  Future<BookmarksResponseModel> getBookmarks(int projectId);
  Future<void> deleteBookmark(int projectId);
  Future<BookmarksResponseModel> getAllBookmarks(int userId);
}