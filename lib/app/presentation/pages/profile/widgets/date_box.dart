import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class DateBox extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const DateBox({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration( 
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6E9EF)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CommonText(label),
            const SizedBox(width: 12),
            const Icon(Icons.calendar_today, size: 18, color: Colors.black54),
          ],
        ),
      ),
    );
  }
} 