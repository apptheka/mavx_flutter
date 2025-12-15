abstract class EmailRepository {
  Future<bool> sendEmail({
    required String to,
    required String subject,
    required String type,
    required String content,
  });
}
