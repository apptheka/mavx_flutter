import 'dart:convert';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/services/extensions.dart';
import 'package:mavx_flutter/app/data/models/completed_projects_model.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart';
import 'package:mavx_flutter/app/domain/repositories/my_project_repository.dart';

class MyProjectsRepositoryImpl extends MyProjectRepository{
  final ApiProvider apiProvider = Get.find<ApiProvider>();

  @override
  Future<List< ProjectModel>> getMyConfirmedProjects() async {
    try {
      final enc = await apiProvider.get(AppConstants.myProjects);
      final decoded = jsonDecode(enc.decrypt());
      final resp =  ProjectResponse.fromJson(decoded);
      final list = resp.data?.data ?? <ProjectModel>[];
      return list;
    } catch (e) {
      throw Exception('Fetching confirmed projects failed: ${e.toString()}');
    }
  }
}