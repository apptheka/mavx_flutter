import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarWidget extends StatelessWidget {
  const SnackBarWidget({super.key, required this.title, required this.message, required this.backgroundColor, required this.colorText});

  final String title;
  final String message;
  final Color backgroundColor;
  final Color colorText;

  @override
  Widget build(BuildContext context) {
    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: colorText,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
    return const SizedBox.shrink();
  }
}
 
void showSnackBar({
  required String title,
  required String message,
  Color backgroundColor = Colors.black87,
  Color colorText = Colors.white,
  SnackPosition snackPosition = SnackPosition.BOTTOM,
  Duration duration = const Duration(seconds: 2),
}) {
  // Avoid stacking multiple snackbars
  if (Get.isSnackbarOpen == true) {
    Get.closeAllSnackbars();
  }

  Get.snackbar(
    title,
    message,
    backgroundColor: backgroundColor,
    colorText: colorText,
    snackPosition: snackPosition,
    duration: duration,
    margin: const EdgeInsets.all(12),
    borderRadius: 12,
  );
}
