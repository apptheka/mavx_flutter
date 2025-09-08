import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/apply/apply_controller.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class UploadDropArea extends StatelessWidget {
  const UploadDropArea({super.key, required this.controller  });
  final ApplyController controller;

  @override
  Widget build(BuildContext context) {
    final isSmall = MediaQuery.of(context).size.width < 360;
    return Obx(() {
      final hasFile = controller.uploadedFileName.value.isNotEmpty;
      final uploading = controller.uploading.value;

      return Container(
        width: double.infinity,
        height: isSmall ? 130 : 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: const Color(0xFFE6E9EF)),
        ),
        child: InkWell(
          onTap: uploading ? null : controller.pickAndUpload,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.upload,
                  size: isSmall ? 32 : 36,
                  color: Colors.black38,
                ),
                const SizedBox(height: 6),
                CommonText(
                  uploading
                      ? 'Uploading...'
                      : (hasFile ? controller.uploadedFileName.value : ''),
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  ), 
              ],
            ),
          ),
        ),
      );
    });
  }
}