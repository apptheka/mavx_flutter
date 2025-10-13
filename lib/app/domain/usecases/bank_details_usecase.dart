import 'package:mavx_flutter/app/domain/repositories/bank_details_repository.dart';

class BankDetailsUseCase {
  final BankDetailsRepository repository;

  BankDetailsUseCase(this.repository);

  Future<void> addBankDetails(Map<String, dynamic> bankDetails) {
    return repository.addBankDetails(bankDetails);
  }
}