import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Service to handle internet connectivity checks across the application
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();

  /// Check if internet connection is available
  /// Returns true if connected, false otherwise
  Future<bool> checkConnectivity() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      // connectivity_plus returns List<ConnectivityResult>
      // Check if the list contains only 'none' or is empty
      return connectivityResult.isNotEmpty &&
          !connectivityResult.contains(ConnectivityResult.none);
    } catch (e) {
      print('Error checking connectivity: $e');
      // If we can't check connectivity, assume no connection
      return false;
    }
  }

  /// Check connectivity and show a dialog if no internet is available
  /// Returns true if connected, false if no internet (dialog shown)
  Future<bool> checkConnectivityWithDialog() async {
    final isConnected = await checkConnectivity();

    print('🌐 Connectivity check result: $isConnected');

    if (!isConnected) {
      print('❌ No internet - showing dialog');
      _showNoInternetDialog();
    } else {
      print('✅ Internet available - proceeding');
    }

    return isConnected;
  }

  /// Show a standardized "No Internet" dialog
  void _showNoInternetDialog() {
    print('📱 Attempting to show no internet dialog');
    print('📱 Get.context is null: ${Get.context == null}');

    if (Get.context == null) {
      print('❌ Cannot show dialog - Get.context is null');
      return;
    }

    print('✅ Showing no internet dialog');
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text('No Internet'),
        content: const Text('Please enable internet to continue.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Stream of connectivity changes
  /// Can be used to listen for connectivity changes in real-time
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
