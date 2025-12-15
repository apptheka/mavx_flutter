import 'package:mavx_flutter/app/domain/repositories/email_repository.dart';

class SendEmailUseCase {
  final EmailRepository repository;
  SendEmailUseCase(this.repository);

  Future<bool> call({
    required String to,
    required String subject,
    required String type,
    required String content,
  }) async {
    return repository.sendEmail(
      to: to,
      subject: subject,
      type: type,
      content: content,
    );
  }
}
