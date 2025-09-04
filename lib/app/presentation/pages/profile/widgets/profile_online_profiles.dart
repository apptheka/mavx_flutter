import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class ProfileOnlineProfiles extends StatelessWidget {
  const ProfileOnlineProfiles({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Online Profiles',
      subtitle: 'Showcase your presence across professional platforms',
      onEdit: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _ProfileItemCard(
            color: Color(0xFF0A66C2),
            label: 'LinkedIn',
            url: 'linkedin.com/in/brucewayne',
            icon: IconAssets.linkedin,
          ),
          SizedBox(height: 12),
          _ProfileItemCard(
            color: Color(0xFF1769FF),
            label: 'Behance',
            url: 'behance.net/brucewayne',
            icon: IconAssets.be,
          ),
          SizedBox(height: 12),
          _ProfileItemCard(
            color: Color(0xFF181717),
            label: 'Github',
            url: 'github.com/smriti-growth',
            icon: IconAssets.github,
          ),
        ],
      ),
    );
  }
}

class _ProfileItemCard extends StatelessWidget {
  final String label;
  final String url;
  final Color color;
  final String icon;
  const _ProfileItemCard({
    required this.label,
    required this.url,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.black.withValues(alpha: 0.08),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(icon, height: 24, width: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(
                  label,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
                const SizedBox(height: 2),
                CommonText(
                  url,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textButtonColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
