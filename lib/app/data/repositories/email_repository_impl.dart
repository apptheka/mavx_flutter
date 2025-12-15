import 'dart:convert';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart';
import 'package:mavx_flutter/app/domain/repositories/email_repository.dart';
import 'package:mavx_flutter/app/core/services/extensions.dart';

class EmailRepositoryImpl implements EmailRepository {
  final ApiProvider apiProvider;
  EmailRepositoryImpl({required this.apiProvider});

  @override
  Future<bool> sendEmail({
    required String to,
    required String subject,
    required String type,
    required String content,
  }) async {
    final body = {
      'to': to,
      'subject': subject,
      'type': type,
      'content': content,
    };
    try {
      // Encrypt payload like other APIs (server expects { request: <encrypted> })
      final encrypted = jsonEncode(body).encript();
      await apiProvider.post(
        AppConstants.sendEmail,
        request: encrypted, 
        headers: const {'area': 'ANDROID'},
        skipAuth: true,
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
