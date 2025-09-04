import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';

class ProfileResume extends StatelessWidget {
  const ProfileResume({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Resume', 
      subtitle: 'Highlight your strongest areas of expertise',
      onEdit: () {},
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.greyColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.black.withValues(alpha: 0.06), width: 2),
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
            Image.asset(IconAssets.resume, height: 20, width: 20, color: AppColors.textSecondaryColor),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'resume.pdf',
                style: TextStyle(color: AppColors.textSecondaryColor, fontWeight: FontWeight.w600),
              ),
            ),
            Spacer(),
            Image.asset(IconAssets.download, height: 20, width: 20),
          ],
        ),
      ),
    );
  }
}
