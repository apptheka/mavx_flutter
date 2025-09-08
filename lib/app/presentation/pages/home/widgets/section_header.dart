import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final int total;
  final String? actionText;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, required this.total, this.actionText, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CommonText(
            title,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimaryColor,
          ),
          const SizedBox(width: 8),
          CommonText(
            "(${total.toString()})",
            fontSize: 14,
            color: AppColors.textSecondaryColor,
          ),
          const Spacer(),
          GestureDetector(
            onTap: onAction,
            child: CommonText(
              actionText ?? '',
              fontSize: 13,
              color: AppColors.textButtonColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
