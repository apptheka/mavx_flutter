import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/services/extensions.dart';
import 'package:mavx_flutter/app/data/models/bookmarks_model.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart';
import 'package:mavx_flutter/app/domain/repositories/auth_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/bookmarks_repository.dart';

class BookmarkRepositoryImpl implements BookmarkRepository {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  final AuthRepository authRepository = Get.find<AuthRepository>();
  @override
  Future<BookmarksResponseModel> getBookmarks(int projectId) async {
    try {
      final currentUser = await authRepository.getCurrentUser();
      final id = currentUser?.data.id;
      final request = {"project_id": projectId, "user_id": id};
      final encodedRequest = jsonEncode(request).encript();
      final response = await apiProvider.post(
        AppConstants.bookmark,
        request: encodedRequest,
      );
      final decriptValue = jsonDecode(response.decrypt());
      BookmarksResponseModel bookmarksResponseModel =
          BookmarksResponseModel.fromJson(decriptValue);
      return bookmarksResponseModel;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteBookmark(int projectId) async {
    try {
      final currentUser = await authRepository.getCurrentUser();
      final userId = currentUser?.data.id;
      await apiProvider.get(
        AppConstants.deleteBookmark,
        queryParameters: {
          'project_id': projectId,
          'user_id': userId,
        },
      );
    } catch (e) {
      throw Exception('Delete bookmark failed: ${e.toString()}');
    }
  }

  @override
  Future<BookmarksResponseModel> getAllBookmarks(int userId) async {
    try {
      final response = await apiProvider.get(
        AppConstants.getAllBookmark,
        queryParameters: {
          'user_id': userId,
        },
      );
      log('Decrypted Register ${response.toString()}');
      final decriptValue = jsonDecode(response.decrypt()); 
      log('Decrypted Register ${decriptValue.toString()}');
      return BookmarksResponseModel.fromJson(decriptValue);
    } catch (e) {
      throw Exception('Fetch bookmarks failed: ${e.toString()}');
    }
  }
}
