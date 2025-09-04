import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/services/extensions.dart';
import 'package:mavx_flutter/app/data/models/projects_model.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart';
import 'package:mavx_flutter/app/domain/repositories/projects_repository.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  @override
  Future<ProjectResponse> getProjects({int page = 1, int limit = 10}) async {
    try {
      final res = await apiProvider.get(
        AppConstants.project,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      final decriptValue = jsonDecode(res.decrypt()); 
      ProjectResponse projectResponse = ProjectResponse.fromJson(decriptValue);
      return projectResponse;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }
}
