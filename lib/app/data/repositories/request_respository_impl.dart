import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/services/extensions.dart';
import 'package:mavx_flutter/app/data/models/requests_model.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart';
import 'package:mavx_flutter/app/domain/repositories/request_repository.dart';

class RequestRepositoryImpl implements RequestRepository {
  final ApiProvider apiProvider = Get.find<ApiProvider>();

  @override
  Future<RequestResponse> getRequests(String status) async {
    try {
      final res = await apiProvider.get(
        "${AppConstants.request}?status=$status",
      );
      final decriptValue = jsonDecode(res.decrypt());
      log("Decrypted Requests Response: ${decriptValue.toString()}");
      Map<String, dynamic> responseMap;
      if (decriptValue is Map<String, dynamic>) {
        responseMap = decriptValue;
      } else {
        responseMap = {
          'data': decriptValue,
          'status': 200,
          'message': 'Success',
        };
      }
      log("Response Map: ${responseMap.toString()}");
      final RequestResponse requestResponse = RequestResponse.fromJson(
        responseMap,
      );
      return requestResponse;
    } catch (e) {
      log("Error in getRequests: $e");
      throw Exception('Failed to load requests: ${e.toString()}');
    }
  }

  @override
  Future<RequestResponse> updateRequestStatus(
    int projectId,
    int expertId,
    String newStatus,
    String note,
  ) async {
    try {
      final request = {
        "expertId": expertId,
        "status": newStatus,
        "note": note,
      };
      // Debug: confirm outgoing payload prior to encryption
      log("Outgoing status update payload: ${request.toString()}");
      final encryptedRequest = jsonEncode(request).encript();
      // 1) Primary attempt: POST /project/expert-requests/{projectId}/status
      try {
        final res = await apiProvider.post(
          "${AppConstants.project}/expert-requests/$projectId/status",
          request: encryptedRequest,
        );
        final decrypted = jsonDecode(res.decrypt()); 
        log("Decrypted Requests Response: ${decrypted.toString()}");
        return RequestResponse.fromJson(decrypted);
      } catch (e) {
        log("Primary POST failed for updateRequestStatus: $e");
      } 

      try {
        final patchPayload = {"request": encryptedRequest};
        final res = await apiProvider.patch(
          "${AppConstants.request}/$projectId",
          data: patchPayload,
        );
        final decrypted = res.decrypt();
        final decriptValue = jsonDecode(decrypted);
        log("Decrypted Requests Response (PATCH /{id}): ${decriptValue.toString()}");
        return RequestResponse.fromJson(decriptValue);
      } catch (e) {
        log("Fallback PATCH /{id} failed for updateRequestStatus: $e");
      }

      // 3) Fallback B: POST /update-status with encrypted body
      try {
        final res = await apiProvider.post(
          "${AppConstants.request}/update-status",
          request: encryptedRequest,
        );
        final decrypted = res.decrypt();
        final decriptValue = jsonDecode(decrypted);
        log("Decrypted Requests Response (POST /update-status): ${decriptValue.toString()}");
        return RequestResponse.fromJson(decriptValue);
      } catch (e) {
        log("Fallback POST /update-status failed for updateRequestStatus: $e");
      }

      // If all strategies fail, throw a clear error
      throw Exception('All status update strategies failed. Please verify the API path/method.');
    } catch (e) {
      log("Error in updateRequestStatus: $e");
      throw Exception('Failed to update request status: ${e.toString()}');
    }
  }
}
