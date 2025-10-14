import 'package:mavx_flutter/app/data/models/expense_model.dart';

abstract class ExpenseRepository {
  Future<ExpensesResponse> getExpenses(int projectId, int expertId);
  Future<bool> createExpense(Map<String, dynamic> payload);
  Future<bool> updateExpense(int id, Map<String, dynamic> payload); 
  Future<bool> upsertExpenses(List<Map<String, dynamic>> payloads);
}