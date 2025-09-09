import 'dart:convert'; 

import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/services/extensions.dart';
import 'package:mavx_flutter/app/data/models/projects_model.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart';
import 'package:mavx_flutter/app/domain/repositories/projects_repository.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  @override
  Future<ProjectResponse> getProjects({int page = 1, int? limit}) async {
    try {
      final params = <String, dynamic>{'page': page};
      if (limit != null) params['limit'] = limit;
      final res = await apiProvider.get(
        AppConstants.project,
        queryParameters: params,
      );
      final decriptValue = jsonDecode(res.decrypt()); 
      ProjectResponse projectResponse = ProjectResponse.fromJson(decriptValue);
      return projectResponse;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }


  @override
  Future<ProjectResponse> projectById(int id) async {
    try {
      final res = await apiProvider.get(
        "${AppConstants.project}/$id",
      );
      final decriptValue = jsonDecode(res.decrypt()); 
      ProjectResponse projectResponse = ProjectResponse.fromJson(decriptValue);
      return projectResponse;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  @override
  Future<ProjectResponse> searchProjects({
    required String search,
    String type = '',
    String industry = '',
    String specialisation = '',
    int page = 1,
    int? limit,
  }) async {
    try {
      final params = <String, dynamic>{
        'search': search,
        'type': type,
        'industry': industry,
        'specialisation': specialisation,
        'page': page,
      };
      if (limit != null) params['limit'] = limit;
      final res = await apiProvider.get(
        AppConstants.projectSearch,
        queryParameters: params,
      );
      final decriptValue = jsonDecode(res.decrypt());
      final ProjectResponse projectResponse = ProjectResponse.fromJson(decriptValue);
      return projectResponse;
    } catch (e) {
      throw Exception('Search failed: ${e.toString()}');
    }
  }


 
}
