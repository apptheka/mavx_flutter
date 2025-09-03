import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';

class CustomStepper extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  const CustomStepper({super.key, this.currentStep = 1, this.totalSteps = 4});

  @override
  Widget build(BuildContext context) {
    return buildStepper(context: context, currentStep: currentStep, totalSteps: totalSteps);
  }

  Widget buildStepper({
    required BuildContext context,
    required int currentStep,
    required int totalSteps,
  }) {
    assert(totalSteps > 1);
    currentStep = currentStep.clamp(1, totalSteps);

    Widget dot(int index) {
      final bool isFilled = index <= currentStep;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isFilled ? AppColors.primaryColor : const Color(0xFFE6E7E8),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          style: TextStyle(
            color: isFilled ? Colors.white : const Color(0xFF8D8D8D),
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
          child: Text(index.toString()),
        ),
      );
    }

    Widget line(bool filled) {
      return Expanded(
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          tween: Tween<double>(
            begin: filled ? 0.0 : 0.0,
            end: filled ? 1.0 : 0.0,
          ),
          builder: (context, value, _) {
            return Stack(
              children: [
                Container(height: 2, color: const Color(0xFFE6E7E8)),
                FractionallySizedBox(
                  widthFactor: value,
                  alignment: Alignment.centerLeft,
                  child: Container(height: 2, color: AppColors.primaryColor),
                ),
              ],
            );
          },
        ),
      );
    }

    final items = <Widget>[];
    for (int i = 1; i <= totalSteps; i++) {
      if (i > 1) items.add(line(i <= currentStep));
      items.add(dot(i));
    }

    final width = MediaQuery.of(context).size.width;
    // Horizontal padding scales with screen width; clamped for extremes
    final horizontalPadding = width * 0.1;
    final clampedPadding = horizontalPadding.clamp(16.0, 80.0);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: clampedPadding),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: items),
    );
  }
}