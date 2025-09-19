import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/services/extensions.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart';
import 'package:mavx_flutter/app/domain/repositories/apply_job_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/auth_repository.dart';
import 'dart:convert';
import 'package:mavx_flutter/app/data/models/projects_model.dart';

class ApplyJobRepositoryImpl implements ApplyJobRepository{
  final ApiProvider apiProvider = Get.find<ApiProvider>(); 
  final AuthRepository authRepository = Get.find<AuthRepository>();

  @override
  Future<String> applyJob({
    required int projectId, 
    required String encryptedRequest,
  }) async {
    try {
      final currentUser = await authRepository.getCurrentUser();
      final userId = currentUser?.data.id;
      final response = await apiProvider.post(
        AppConstants.applyJob,
        queryParameters: {
          'project_id': projectId,
          'user_id': userId,
        },
        request: encryptedRequest,
      );
      // If backend returns encrypted string, decrypt; else pass through
      try {
        final decrypted = response.decrypt();
        return decrypted;
      } catch (_) {
        return response;
      }
    } catch (e) {
      throw Exception('Apply job failed: ${e.toString()}');
    }
  }

  @override
  Future<Set<int>> getAppliedProjectIdsForCurrentUser() async {
    try {
      final currentUser = await authRepository.getCurrentUser();
      final userId = currentUser?.data.id;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      final idsEnc = await apiProvider.get('${AppConstants.getApplyJob}/$userId');
      final idsJson = jsonDecode(idsEnc.decrypt());
      final idsListRaw = (idsJson is Map)
          ? (idsJson['data']?['data'] ?? idsJson['data'] ?? idsJson)
          : idsJson;
      final Set<int> appliedIds = <int>{};
      if (idsListRaw is List) {
        for (final item in idsListRaw) {
          if (item is Map && item['project_id'] != null) {
            final id = int.tryParse(item['project_id'].toString());
            if (id != null) appliedIds.add(id);
          } else if (item is int) {
            appliedIds.add(item);
          }
        }
      }
      return appliedIds;
    } catch (e) {
      throw Exception('Fetching applied project IDs failed: ${e.toString()}');
    }
  }

  @override
  Future<List<ProjectModel>> getAppliedProjectsForCurrentUser() async {
    try {
      final currentUser = await authRepository.getCurrentUser();
      final userId = currentUser?.data.id;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      // 1) Get applied project IDs
      final appliedIds = await getAppliedProjectIdsForCurrentUser();

      // 2) Try bulk details endpoint first
      try {
        final detailsEnc = await apiProvider.get('${AppConstants.getUserApplyProjects}/$userId');
        final detailsJson = jsonDecode(detailsEnc.decrypt());
        final ProjectResponse response = ProjectResponse.fromJson(detailsJson);
        final List<ProjectModel> projects = response.data?.data ?? [];
        if (appliedIds.isNotEmpty) {
          return projects.where((p) => p.id != null && appliedIds.contains(p.id!)).toList();
        }
        return projects;
      } catch (_) {
        // 3) Fallback: fetch each project by id
        final List<ProjectModel> result = [];
        for (final id in appliedIds) {
          try {
            final enc = await apiProvider.get('${AppConstants.project}/$id');
            final json = jsonDecode(enc.decrypt());
            final resp = ProjectResponse.fromJson(json);
            if (resp.data != null && resp.data!.data != null && resp.data!.data!.isNotEmpty) {
              result.addAll(resp.data!.data!);
            }
          } catch (_) {
            // skip this id on error
          }
        }
        return result;
      }
    } catch (e) {
      throw Exception('Fetching applied projects failed: ${e.toString()}');
    }
  }
}