import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';

class ProfileAbout extends StatelessWidget {
  const ProfileAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'About Me',
      onEdit: () {},
      child: Text(
        'Seasoned consultant focused on digital transformation and operational excellence. Passionate about driving measurable impact. ',
        style: TextStyle(color: AppColors.textSecondaryColor, height: 1.4),
      ),
    );
  }
}
