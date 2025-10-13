 import 'dart:convert';

import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/services/extensions.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart';
import 'package:mavx_flutter/app/domain/repositories/bank_details_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/auth_repository.dart';
import 'package:get/get.dart';

class BankDetailsRepositoryImpl implements BankDetailsRepository {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  final AuthRepository authRepository = Get.find<AuthRepository>();
  @override
  Future<void> addBankDetails(Map<String, dynamic> bankDetails) async {
    try {
      final user = await authRepository.getCurrentUser();
      final userId = user?.data.id;

      final payload = Map<String, dynamic>.from(bankDetails)
        ..removeWhere((k, v) => v == null || (v is String && v.trim().isEmpty))
        ..addAll({'user_id': userId});

      final encryptedRequest = jsonEncode(payload).encript();

      final resp = await apiProvider.post(
        AppConstants.bankDetails,
        request: encryptedRequest,
      );

      try {
        final decoded = jsonDecode(resp.decrypt());
        if (decoded is Map && (decoded['status'] == 'success' || decoded['success'] == true)) {
          return;
        }
      } catch (_) {
        // Non-encrypted or non-JSON error text; treat as handled
      }
      return;
    } catch (e) {
      throw e;
    }
  }
}