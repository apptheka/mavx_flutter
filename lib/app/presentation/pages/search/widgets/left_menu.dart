import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class LeftMenuItem extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const LeftMenuItem({super.key, 
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? const Color(0xFF0B2944) : Colors.transparent;
    final fg = selected ? Colors.white : const Color(0xFF0B2944);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: CommonText(
          title,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
