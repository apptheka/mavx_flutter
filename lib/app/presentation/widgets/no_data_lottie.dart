import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class NoDataLottie extends StatelessWidget {
  const NoDataLottie({super.key, required this.text, required this.onPressed});
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
      children: [
      Lottie.asset('assets/lottie/no_data.json', width: 200, height: 200),
      CommonText(
        'No Data Found',
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      const SizedBox(height: 12,),
      ElevatedButton(onPressed: onPressed, child: CommonText(text, fontSize: 16, fontWeight: FontWeight.w600,)),
      ],
      ),
    );  
  }
}
