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
    String _prefixBase(String path) {
      if (path.isEmpty) return path;
      if (path.startsWith('http')) return path;
      return '${AppConstants.baseUrl}$path';
    }
    String rawResume = controller.registeredProfile.value.resume ?? '';
    String resumeUrl = _prefixBase(rawResume);
    return SectionCard(
      title: 'Resume',
      subtitle: 'Highlight your strongest areas of expertise',
      onEdit: () {
        Get.bottomSheet(
          SafeArea(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Edit Resume', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  const Text('Update your professional document', style: TextStyle(color: AppColors.textSecondaryColor)),
                  const SizedBox(height: 12),
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF121212),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.picture_as_pdf, color: Colors.white70, size: 36),
                          const SizedBox(height: 8),
                          Text(
                            rawResume.isNotEmpty ? rawResume.split('/').last : 'No resume found',
                            style: const TextStyle(color: Colors.white70),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () async {
                              if (resumeUrl.isEmpty) {
                                Get.snackbar('Resume', 'No resume to open');
                                return;
                              }
                              await Clipboard.setData(ClipboardData(text: resumeUrl));
                              Get.snackbar('Copied', 'Resume link copied');
                            },
                            child: const Text('Open'),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(onPressed: () => Get.back(), child: const Text('Close')),
                  )
                ],
              ),
            ),
          ),
          isScrollControlled: true,
        );
      },
      child: Obx(() {
        rawResume = controller.registeredProfile.value.resume ?? '';
        resumeUrl = _prefixBase(rawResume);
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
                  maxLines: 1,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryColor,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () async {
                  if (resumeUrl.isEmpty) return;
                  final uri = Uri.parse(resumeUrl);
                  try {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } catch (_) {
                    // Silently ignore if unable to launch
                  }
                },
                child: Image.asset(
                  IconAssets.download,
                  height: 20,
                  width: 20,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
