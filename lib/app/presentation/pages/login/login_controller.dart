import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/domain/usecases/login_usecase.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:signin_with_linkedin/signin_with_linkedin.dart';

class LoginController extends GetxController {
  // Form key to validate inputs
  final formKey = GlobalKey<FormState>();

  // One-time init flag for google_sign_in v7 API
  static bool _googleInited = false;

  //usecase
  final LoginUseCase loginUseCase = Get.find<LoginUseCase>();

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // State
  final isLoading = false.obs;
  final isError = false.obs;
  final isPasswordHidden = true.obs;

  // Validators
  String? validateEmail(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter email';

    // Basic email regex
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

    if (!emailRegex.hasMatch(v)) {
      return 'Enter a valid email';
    }
    return null;
  }

  Future<void> linkedInLogin() async {
      if (isLoading.value) return;
      FocusManager.instance.primaryFocus?.unfocus();
      try {
        isError.value = false;
        isLoading.value = true;

        final ctx = Get.context;
        if (ctx == null) {
          throw Exception('Context not available');
        }

        final clientId = AppConstants.linkedinClientId;
        final clientSecret = AppConstants.linkedinClientSecret;
        final redirectUrl = AppConstants.linkedinRedirectUrl;
        if (clientId.isEmpty || clientSecret.isEmpty || redirectUrl.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final c = Get.context;
            if (c != null) {
              ScaffoldMessenger.of(c).showSnackBar(
                const SnackBar(
                  content: Text(
                    'LinkedIn is not configured. Set linkedinClientId, linkedinClientSecret, linkedinRedirectUrl',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          });
          return;
        }

        final linkedInConfig = LinkedInConfig(
          clientId: clientId,
          clientSecret: clientSecret,
          redirectUrl: redirectUrl,
          scope: const ['openid', 'profile', 'email'],
        );
        final linkedin = SignInWithLinkedIn(config: linkedInConfig);

        final (authCode, authErr) = await linkedin.getAuthorizationCode(
          context: ctx,
        );
        if (authCode == null) {
          throw Exception(
            authErr?.toJson().toString() ?? 'LinkedIn authorization cancelled',
          );
        }

        final (tokenInfo, tokenErr) = await linkedin.getAccessToken(
          authorizationCode: authCode,
        );
        if (tokenInfo == null) {
          throw Exception(
            tokenErr?.toJson().toString() ?? 'LinkedIn token fetch failed',
          );
        }

        final (user, userErr) = await linkedin.getUserInfo(
          tokenInfo: tokenInfo,
        );
        if (user == null) {
          throw Exception(
            userErr?.toJson().toString() ?? 'LinkedIn user info fetch failed',
          );
        }

        final map = user.toJson();
        var email = '';
        final e1 = map['email'];
        final e2 = map['emailAddress'];
        final e3 = map['email_address'];
        if (e1 is String && e1.isNotEmpty)
          email = e1.trim();
        else if (e2 is String && e2.isNotEmpty)
          email = e2.trim();
        else if (e3 is String && e3.isNotEmpty)
          email = e3.trim();

        if (email.isEmpty) {
          throw Exception(
            'LinkedIn account email not available. Ensure email scope is approved.',
          );
        }

        emailController.text = email;

        final res = await loginUseCase.call(email, '', isSocial: true);
        if (res.status == 200) {
          final status = res.data.status.toLowerCase();
          if (status == 'pending') {
            await _showPendingDialog();
          } else {
            Get.offAllNamed(AppRoutes.dashboard);
          }
          log(res.message);
        } else {
          isError.value = true;
          final msg = (res.message.isNotEmpty) ? res.message : 'Login failed';
          final c = Get.context;
          if (c != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(c).showSnackBar(
                SnackBar(content: Text(msg), backgroundColor: Colors.red),
              );
            });
          }
        }
      } catch (e) {
        isError.value = true;
        final msg = e.toString().replaceAll('Exception: ', '');
        log(msg);
        final c = Get.context;
        if (c != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(c).showSnackBar(
              SnackBar(content: Text(msg), backgroundColor: Colors.red),
            );
          });
        }
      } finally {
        isLoading.value = false;
      }
    }

  String? validatePassword(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter password';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  void signIn() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final form = formKey.currentState;
    if (form == null) return;

    if (!form.validate()) {
      isError.value = true;
      return; // Block sign-in when invalid
    }

    // Proceed with sign-in
    try {
      isError.value = false;
      isLoading.value = true;
      final res = await loginUseCase.call(
        emailController.text,
        passwordController.text,
      );
      if (res.status == 200) {
        final status = res.data.status.toLowerCase();
        if (status == 'pending') {
          await _showPendingDialog();
          // stay on login; user will be able to access after approval
        } else {
          Get.offAllNamed(AppRoutes.dashboard);
        }
        log(res.message);
      } else {
        isError.value = true;
        log(res.message);
        final msg = (res.message.isNotEmpty)
            ? res.message
            : 'Invalid email or password';
        Get.snackbar(
          'Error',
          msg,
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      isError.value = true;
      final err = e.toString();
      log(err);
      String uiMsg = 'Invalid email or password';
      final lower = err.toLowerCase();
      if (lower.contains('401') || lower.contains('unauthorized')) {
        uiMsg = 'Invalid email or password';
      } else if (lower.contains('timeout')) {
        uiMsg = 'Connection timeout. Please try again.';
      }
      Get.snackbar(
        'Error',
        uiMsg,
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
    isLoading.value = false;
  }

  // Social login: only email is sent to backend with is_social=true
  Future<void> socialLogin() async {
    if (isLoading.value) return;
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      isError.value = false;
      isLoading.value = true;
      if (!_googleInited) {
        final cid = AppConstants.googleServerClientId;
        if (cid.isEmpty || cid == 'YOUR_WEB_CLIENT_ID') {
          final ctx = Get.context;
          if (ctx != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Google Sign-In not configured. Set AppConstants.googleServerClientId',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            });
          }
          return;
        }
        await GoogleSignIn.instance.initialize(serverClientId: cid);
        _googleInited = true;
      }
      final account = await GoogleSignIn.instance.authenticate(
        scopeHint: const ['email'],
      );
      final email = account.email.trim();
      emailController.text = email; // reflect chosen email in UI

      final res = await loginUseCase.call(email, '', isSocial: true);
      if (res.status == 200) {
        final status = res.data.status.toLowerCase();
        if (status == 'pending') {
          await _showPendingDialog();
        } else {
          Get.offAllNamed(AppRoutes.dashboard);
        }
        log(res.message);
      } else {
        isError.value = true;
        final msg = (res.message.isNotEmpty) ? res.message : 'Login failed';
        final ctx = Get.context;
        if (ctx != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(content: Text(msg), backgroundColor: Colors.red),
            );
          });
        }
      }
    } on GoogleSignInException catch (e) {
      // Treat user cancel/UI issues silently; surface other errors
      final code = e.code.name.toLowerCase();
      if (code.contains('canceled') ||
          code.contains('cancelled') ||
          code.contains('uiunavailable') ||
          code.contains('interrupted')) {
        return;
      }
      isError.value = true;
      final msg = (e.toString()).toString();
      log(msg);
      final ctx = Get.context;
      if (ctx != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text(msg), backgroundColor: Colors.red),
          );
        });
      }
    } catch (e) {
      isError.value = true;
      final msg = e.toString().replaceAll('Exception: ', '');
      log(msg);
      final ctx = Get.context;
      if (ctx != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(content: Text(msg), backgroundColor: Colors.red),
          );
        });
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _showPendingDialog() async {
    return Get.dialog(
      AlertDialog(
        title: const CommonText(
          'Profile Under Review',
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        content: const CommonText(
          'Your profile is under review. You will be notified once approved. You can log in after approval.',
          fontSize: 14,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const CommonText(
              'OK',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
