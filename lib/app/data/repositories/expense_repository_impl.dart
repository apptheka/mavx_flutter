import 'dart:convert';

import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/services/extensions.dart';
import 'package:mavx_flutter/app/data/models/expense_model.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart';
import 'package:mavx_flutter/app/domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ApiProvider apiProvider = Get.find<ApiProvider>();
  @override
  Future<bool> createExpense(Map<String, dynamic> payload) async {
    try {
      final jsonPayload = jsonEncode([payload]);
      final encrypted = jsonPayload.encript();
      final resp = await apiProvider.post(AppConstants.upsertExpenses, request: encrypted);
      // Some endpoints return plain string or nested data; treat any non-empty response as success
      return resp.toString().isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> upsertExpenses(List<Map<String, dynamic>> payloads) async {
    try {
      final jsonPayload = jsonEncode(payloads);
      final encrypted = jsonPayload.encript();
      final resp = await apiProvider.post(AppConstants.upsertExpenses, request: encrypted);
      return resp.toString().isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<ExpensesResponse> getExpenses(int projectId, int expertId) async {
    try {
      final response = await apiProvider.get(AppConstants.getExpenses.replaceFirst('{projectId}', projectId.toString()).replaceFirst('{expertId}', expertId.toString()));
      final decodedResponse = jsonDecode(response.decrypt());
      ExpensesResponse expensesResponse = ExpensesResponse.fromJson(decodedResponse);
      return expensesResponse;
    }catch(e){
      return ExpensesResponse(status: 500, message: 'Failed to fetch expenses', data: []);
    }
  }

  @override
  Future<bool> updateExpense(int id, Map<String, dynamic> payload) async {
    try {
      final body = Map<String, dynamic>.from(payload);
      body['id'] = id;
      final jsonPayload = jsonEncode([body]);
      final encrypted = jsonPayload.encript();
      final resp = await apiProvider.post(AppConstants.upsertExpenses, request: encrypted);
      return resp.toString().isNotEmpty;
    } catch (_) {
      return false;
    }
  }
   
}