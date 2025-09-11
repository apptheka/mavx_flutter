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
      final hasUploaded = controller.uploadedFileName.value.isNotEmpty;
      final existingUrl = controller.existingResumeUrl.value;
      final hasExisting = existingUrl.isNotEmpty;
      final uploading = controller.uploading.value;

      // Derive current file display
      String currentName() {
        if (hasUploaded) return controller.uploadedFileName.value;
        if (hasExisting) return existingUrl.split('/').last;
        return '';
      }

      IconData currentIcon() {
        final name = currentName().toLowerCase();
        if (name.endsWith('.pdf')) return Icons.picture_as_pdf;
        if (name.endsWith('.doc') || name.endsWith('.docx')) return Icons.description;
        if (name.endsWith('.png') || name.endsWith('.jpg') || name.endsWith('.jpeg')) return Icons.image;
        return Icons.insert_drive_file;
      }

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
            child: uploading
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(strokeWidth: 2),
                      const SizedBox(height: 8),
                      const CommonText(
                        'Uploading...',
                        color: Colors.black54,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  )
                : ((hasUploaded || hasExisting)
                    // Show current resume indicator
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            currentIcon(),
                            size: isSmall ? 28 : 32,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CommonText(
                                  currentName(),
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                                const SizedBox(height: 2),
                                const CommonText(
                                  'Tap to change',
                                  color: Colors.black45,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    // Default prompt
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.upload,
                            size: isSmall ? 32 : 36,
                            color: Colors.black38,
                          ),
                          const SizedBox(height: 6),
                          const CommonText(
                            'Tap to upload CV',
                            color: Colors.black54,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      )),
          ),
        ),
      );
    });
  }
}