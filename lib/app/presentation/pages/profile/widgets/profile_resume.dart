import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart'; 
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileResume extends StatelessWidget {
  final ProfileController controller;
  const ProfileResume({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    String prefixBase(String path) {
      if (path.isEmpty) return path;
      if (path.startsWith('http')) return path;
      // Use baseUrlImage for static file hosting and ensure '/uploads'
      final base = AppConstants.baseUrlImage.endsWith('/')
          ? AppConstants.baseUrlImage
          : '${AppConstants.baseUrlImage}/';
      String clean = path.trim();
      if (clean.startsWith('/')) clean = clean.substring(1);
      if (!clean.startsWith('uploads/')) {
        clean = 'uploads/$clean';
      }
      return '$base$clean';
    }

    String rawResume = controller.registeredProfile.value.resume ?? '';
    String resumeUrl = prefixBase(rawResume);
    return SectionCard(
      title: 'Resume',
      subtitle: 'Highlight your strongest areas of expertise',
      // onEdit: () {
      //   Get.bottomSheet(
      //     BackdropFilter(
      //       filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      //       child: Container(
      //         padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      //         decoration: const BoxDecoration(
      //           color: Colors.white,
      //           borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      //         ),
      //         child: Column(
      //           mainAxisSize: MainAxisSize.min,
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             const Text(
      //               'Edit Resume',
      //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
      //             ),
      //             const SizedBox(height: 6),
      //             const Text(
      //               'Update your professional document',
      //               style: TextStyle(color: AppColors.textSecondaryColor),
      //             ),
      //             const SizedBox(height: 12),
      //             Container(
      //               height: 180,
      //               width: double.infinity,
      //               decoration: BoxDecoration(
      //                 color: AppColors.greyColor,
      //                 borderRadius: BorderRadius.circular(12),
      //                 border: Border.all(
      //                   color: AppColors.black.withValues(alpha: 0.06),
      //                   width: 2,
      //                 ),
      //                 boxShadow: [
      //                   BoxShadow(
      //                     color: Colors.black.withValues(alpha: 0.06),
      //                     blurRadius: 10,
      //                     offset: const Offset(0, 4),
      //                   ),
      //                 ],
      //               ),
      //               child: Center(
      //                 child: Column(
      //                   mainAxisSize: MainAxisSize.min,
      //                   children: [
      //                     const Icon(
      //                       Icons.picture_as_pdf,
      //                       color: AppColors.textSecondaryColor,
      //                       size: 36,
      //                     ),
      //                     const SizedBox(height: 8),
      //                     CommonText(
      //                       rawResume.isNotEmpty
      //                           ? rawResume.split('/').last
      //                           : 'No resume found',
      //                       color: AppColors.textSecondaryColor, 
      //                       fontSize: 15,
      //                       fontWeight: FontWeight.w600,
      //                       overflow: TextOverflow.ellipsis,
      //                     ),
      //                     const SizedBox(height: 12),
      //                     SizedBox(
      //                       width: MediaQuery.of(context).size.width * 0.4,
      //                       child: ElevatedButton(
      //                         onPressed: () {
                            
      //                         },
      //                         child: const CommonText(
      //                           'Open',
      //                           fontSize: 15,
      //                           fontWeight: FontWeight.w600,
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //             const SizedBox(height: 12),
      //             Align(
      //               alignment: Alignment.centerRight,
      //               child: TextButton(
      //                 onPressed: () => Get.back(),
      //                 child: const Text('Close'),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //     isScrollControlled: true,
      //   );
      // },
      child: Obx(() {
        rawResume = controller.registeredProfile.value.resume ?? '';
        resumeUrl = prefixBase(rawResume);
        final displayName = rawResume.isNotEmpty
            ? rawResume.split('/').last
            : 'No resume found';
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.greyColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.black.withValues(alpha: 0.06),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Image.asset(
                IconAssets.resume,
                height: 20,
                width: 20,
                color: AppColors.textSecondaryColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CommonText(
                  displayName,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryColor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () async {
                  final url = resumeUrl.trim();
                  if (url.isEmpty) {
                    Get.snackbar(
                      'Resume',
                      'No resume found to preview',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                    );
                    return;
                  }
                  final uri = Uri.tryParse(url);
                  if (uri == null) {
                    Get.snackbar(
                      'Resume',
                      'Invalid resume link',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                    );
                    return;
                  }
                  if (!await canLaunchUrl(uri)) {
                    Get.snackbar(
                      'Resume',
                      'Could not open resume',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                    );
                    return;
                  }
                  await launchUrl(
                    uri,
                    mode: LaunchMode.inAppWebView,
                    webViewConfiguration: const WebViewConfiguration(
                      enableJavaScript: true,
                    ),
                  );
                },
                child: Icon(Icons.remove_red_eye)
              ),
            ],
          ),
        );
      }),
    );
  }
}
