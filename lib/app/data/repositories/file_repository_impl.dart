import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/services/extensions.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart';
import 'package:mavx_flutter/app/domain/repositories/file_repository.dart';

class FileRepositoryImpl implements FileRepository {
  final ApiProvider _api = Get.find<ApiProvider>();

  @override
  Future<String> uploadFile({
    required String fieldName,
    required String filePath,
    Map<String, String>? fields,
  }) async {
    try {
      // Perform multipart upload
      final respStr = await _api.postMultipart(
        AppConstants.fileUploading,
        fields: fields,
        files: {
          fieldName: filePath,
        },
      );

      // Quick guard: if server returned HTML (common for 404/500 fallback pages),
      // fail fast with a clear message instead of trying to decrypt/JSON-parse.
      final trimmed = respStr.trimLeft();
      if (trimmed.startsWith('<!DOCTYPE html') || trimmed.startsWith('<html')) {
        throw Exception('Upload endpoint returned HTML (likely 404). Please verify AppConstants.baseUrl + AppConstants.fileUploading');
      }

      // Server may return encrypted string; attempt decrypt -> JSON
      Map<String, dynamic> json;
      try {
        json = jsonDecode(respStr);
      } catch (_) {
        final decrypted = respStr.decrypt();
        json = jsonDecode(decrypted);
      }
      log('file upload response json: $json');

      // Try flexible extraction of URL
      // Expected shapes: {data: {url: ...}} or {data: {fileUrl: ...}} or {url: ...}
      String? url;
      final data = json['data'];
      if (data is Map) {
        url = (data['url'] ?? data['fileUrl'] ?? data['path'] ?? data['location'])?.toString();
      }
      url ??= (json['url'] ?? json['fileUrl'] ?? json['path'] ?? json['location'])?.toString();

      if (url == null || url.isEmpty) {
        throw Exception('File URL missing in upload response');
      }
      return url;
    } catch (e, st) {
      log('uploadFile failed: $e', stackTrace: st);
      throw Exception('Upload failed: ${e.toString()}');
    }
  }
}
