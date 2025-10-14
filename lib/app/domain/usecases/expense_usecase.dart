import 'package:mavx_flutter/app/data/models/expense_model.dart';
import 'package:mavx_flutter/app/domain/repositories/expense_repository.dart';

class ExpenseUseCase {
  final ExpenseRepository expenseRepository;

  ExpenseUseCase({required this.expenseRepository});

  Future<ExpensesResponse> getExpenses(int projectId, int expertId) async {
    return await expenseRepository.getExpenses(projectId, expertId);
  }

  Future<bool> createExpense(Map<String, dynamic> payload) async {
    return await expenseRepository.createExpense(payload);
  }

  Future<bool> updateExpense(int id, Map<String, dynamic> payload) async {
    return await expenseRepository.updateExpense(id, payload);
  }

  Future<bool> upsertExpenses(List<Map<String, dynamic>> payloads) async {
    return await expenseRepository.upsertExpenses(payloads);
  }
}
