import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';

class ProgressDot extends StatelessWidget {
  final bool active;
  const ProgressDot({required this.active, super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: active ? 16 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? AppColors.textBlueColor : AppColors.greyColor,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}