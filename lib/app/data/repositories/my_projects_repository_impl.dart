import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/services/extensions.dart';
import 'package:mavx_flutter/app/data/models/completed_projects_model.dart';
import 'package:mavx_flutter/app/data/models/timesheet_model.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart';
import 'package:mavx_flutter/app/domain/repositories/my_project_repository.dart';

class MyProjectsRepositoryImpl extends MyProjectRepository {
  final ApiProvider apiProvider = Get.find<ApiProvider>();

  @override
  Future<List<ProjectModel>> getMyConfirmedProjects() async {
    try {
      final enc = await apiProvider.get(AppConstants.myProjects);
      final decoded = jsonDecode(enc.decrypt());
      log(decoded.toString());
      final resp = ProjectResponse.fromJson(decoded);
      final list = resp.data?.data ?? <ProjectModel>[];
      return list;
    } catch (e) {
      throw Exception('Fetching confirmed projects failed: ${e.toString()}');
    }
  }

  @override
  Future<bool> uploadInvoice({required Map<String, String> fields, String? filePath}) async {
    try {
      final resp = await apiProvider.postMultipart(
        AppConstants.invoice,
        fields: fields,
        files: filePath != null && filePath.isNotEmpty ? {'invoice_file': filePath} : null,
      );
      if (resp.isEmpty) return false;
      try {
        final decrypted = resp.decrypt();
        final decoded = jsonDecode(decrypted);
        if (decoded is Map<String, dynamic>) {
          final status = decoded['status'] ?? decoded['code'];
          final message = decoded['message']?.toString().toLowerCase();
          if (status is int && status >= 200 && status < 300) return true;
          if (message != null && (message.contains('success') || message.contains('created') || message.contains('uploaded'))) return true;
          if (decoded['data'] != null) return true;
        }
      } catch (_) {
        try {
          final decoded = jsonDecode(resp);
          if (decoded is Map<String, dynamic>) {
            final status = decoded['status'] ?? decoded['code'];
            if (status is int && status >= 200 && status < 300) return true;
          }
        } catch (_) {}
      }
      return resp.isNotEmpty;
    } catch (e) {
      throw Exception('Invoice upload failed: ${e.toString()}');
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
          if (message != null &&
              (message.contains('success') || message.contains('created')))
            return true;
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

  @override
  Future<List<Timesheet>> getTimesheets(int projectId, int expertId) async {
    try {
      // Build endpoint: /timesheet/project/{projectId}/expert/{expertId}
      String path = AppConstants.getTimesheet
          .replaceAll('{projectId}', projectId.toString())
          .replaceAll('{expertId}', expertId.toString());

      final enc = await apiProvider.get(path);

      // Try to decrypt first (normal flow)
      try {
        final decrypted = enc.decrypt();
        final decoded = jsonDecode(decrypted);
        log("decoded: $decoded");
        if (decoded is Map<String, dynamic>) {
          final resp = TimesheetsResponse.fromJson(decoded);
          return resp.data;
        }
      } catch (_) {
        // If decrypt fails, try parse as plain JSON
        try {
          final decoded = jsonDecode(enc);
          if (decoded is Map<String, dynamic>) {
            final resp = TimesheetsResponse.fromJson(decoded);
            return resp.data;
          }
        } catch (e2) {
          // fallthrough to throw below
        }
      }

      // If parsing failed, return empty list
      return <Timesheet>[];
    } catch (e) {
      throw Exception('Fetching timesheets failed: ${e.toString()}');
    }
  }
}
