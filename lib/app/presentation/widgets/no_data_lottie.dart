import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class NoDataLottie extends StatelessWidget {
  const NoDataLottie({super.key, required this.buttonText, required this.onPressed, required this.title});
  final String buttonText;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Use the existing lottie asset filename present in assets/lottie/
          Lottie.asset(
            'assets/lottie/No Search result.json',
            width: 200,
            height: 200,
            repeat: true,
            errorBuilder: (context, error, stack) => const Icon(Icons.hourglass_empty, size: 80, color: Colors.grey),
          ),
          const SizedBox(height: 8),
            CommonText(
            title,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.06,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                )
              ),
              onPressed: onPressed,
              child: CommonText(
                buttonText,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
