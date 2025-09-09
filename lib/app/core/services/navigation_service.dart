import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/domain/repositories/notification_repository.dart'; 

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<dynamic> pushNamed(String routeName) {
    return _instance.navigatorKey.currentState?.pushNamed(routeName) ??
        Future.value();
  }

  Future<void> logout() async {
    await _removeDeviceRegistration();
    await _clearSession();
    _navigateToLogin();
  }

  Future<void> _removeDeviceRegistration() async {
    try {
      final deviceId =
          Hive.box(HiveConstant.APP_BOX).get(HiveFieldConstant.DEVICE_ID);
      final fcmToken =
          Hive.box(HiveConstant.APP_BOX).get(HiveFieldConstant.FCM_TOKEN);

      if (deviceId != null && fcmToken != null) {
        final notificationRepository = GetIt.I<NotificationRepository>();

        await notificationRepository.removeDevice();
      }
    } catch (e) {
      // Log error but continue with logout
      debugPrint('Error removing device registration: $e');
    }
  }

  Future<void> _clearSession() async {
    await Hive.box(HiveConstant.APP_BOX).clear();
  }

  void _navigateToLogin() {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppConstants.loginRoute,
      (route) => false,
    );
  }
}
