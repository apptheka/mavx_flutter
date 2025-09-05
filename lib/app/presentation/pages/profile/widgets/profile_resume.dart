import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';

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
    final rawResume = controller.registeredProfile.value.resume ?? '';
    final resumeUrl = _prefixBase(rawResume);
    return SectionCard(
      title: 'Resume',
      subtitle: 'Highlight your strongest areas of expertise',
      onEdit: () {},
      child: 
          Container(
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
                    resumeUrl,
                    fontSize: 15,
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
          ),
    );
  }
}
