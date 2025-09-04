import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final int total;
  final String actionText;
  final VoidCallback? onAction;

  const SectionHeader({super.key, required this.title, required this.total, this.actionText = 'View all', this.onAction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimaryColor),
          ),
          const SizedBox(width: 8),
          Text("(${total.toString()})", style: const TextStyle(fontSize: 14, color: AppColors.textSecondaryColor)),
          const Spacer(),
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionText,
              style: const TextStyle(color: AppColors.textButtonColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
