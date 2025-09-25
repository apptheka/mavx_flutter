import 'dart:convert';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/services/extensions.dart';
import 'package:mavx_flutter/app/data/models/completed_projects_model.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart';
import 'package:mavx_flutter/app/domain/repositories/my_project_repository.dart';

class MyProjectsRepositoryImpl extends MyProjectRepository {
  final ApiProvider apiProvider = Get.find<ApiProvider>();

  @override
  Future<List<ProjectModel>> getMyConfirmedProjects() async {
    try {
      final enc = await apiProvider.get(AppConstants.myProjects);
      final decoded = jsonDecode(enc.decrypt());
      final resp = ProjectResponse.fromJson(decoded);
      final list = resp.data?.data ?? <ProjectModel>[];
      return list;
    } catch (e) {
      throw Exception('Fetching confirmed projects failed: ${e.toString()}');
    }
  }

  @override
  Future<bool> createProjectSchedule(Map<String, dynamic> payload) async {
    try {
      // Encrypt the payload like other API calls
      final jsonPayload = jsonEncode(payload);
      final encryptedPayload = jsonPayload.encript();
      
      final resp = await apiProvider.post(
        AppConstants.timesheet,
        request: encryptedPayload,
      );
      
      if (resp.isEmpty) return false;
      
      // Decrypt and parse the response
      try {
        final decrypted = resp.decrypt();
        final decoded = jsonDecode(decrypted);
        
        if (decoded is Map<String, dynamic>) {
          final status = decoded['status'] ?? decoded['code'];
          final message = decoded['message']?.toString().toLowerCase();
          final data = decoded['data'];
          
          // Check for success indicators
          if (status is int && status >= 200 && status < 300) return true;
          if (message != null && (message.contains('success') || message.contains('created'))) return true;
          if (data != null && data is Map && data.isNotEmpty) return true;
        }
      } catch (decryptError) {
        // If decryption fails, try parsing as plain JSON
        try {
          final decoded = jsonDecode(resp);
          if (decoded is Map<String, dynamic>) {
            final status = decoded['status'] ?? decoded['code'];
            if (status is int && status >= 200 && status < 300) return true;
          }
        } catch (_) {
          // ignore parse errors
        }
      }
      
      // If we get here, check if response indicates success
      return resp.isNotEmpty;
    } catch (e) {
      throw Exception('Timesheet creation failed: ${e.toString()}');
    }
  }
}
