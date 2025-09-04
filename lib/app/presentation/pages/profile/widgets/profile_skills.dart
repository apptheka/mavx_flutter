import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/section_card.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';

class ProfileSkills extends StatelessWidget {
  const ProfileSkills({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Key Skills',
      subtitle: 'Highlight your strongest areas of expertise',
      onEdit: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical:16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            _Chip(
              text: 'Growth Strategy',
              bgColor: Color(0xFFF6EAD5), 
            ),
            _Chip(
              text: 'GTM',
              bgColor: Color(0xFFEFE7DE), 
            ),
            _Chip(
              text: 'Early-Stage Startups',
              bgColor: Color(0xFFE8E2F7), 
            ),
            _Chip(
              text: 'Retention',
              bgColor: Color(0xFFDFF2EA), 
            ),
            _Chip(
              text: 'Paid Acquisition',
              bgColor: Color(0xFFE3F1FF), 
            ),
            _Chip(
              text: 'Marketplace Ops',
              bgColor: Color(0xFFE7EFF8), 
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color bgColor; 
  const _Chip({
    required this.text,
    this.bgColor = const Color(0xFFEFF4F8), 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.textPrimaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
