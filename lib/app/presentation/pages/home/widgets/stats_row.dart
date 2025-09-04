import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/core/constants/image_assets.dart';

class StatsRow extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  const StatsRow({super.key, this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 8)});

  Widget _statBox(String value, String label, Color color, String image) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black)),
                const SizedBox(height: 4),
                Text(label, style: const TextStyle(color: Colors.black54,fontWeight: FontWeight.w600)),
              ],
            ),
            const Spacer(),
            SizedBox(width: 36, height: 36, child: Image.asset(image, fit: BoxFit.contain)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          _statBox('54', 'Profile Views', const Color(0xff21A241), ImageAssets.profileView),
          const SizedBox(width: 12),
          _statBox('32', 'Saved Jobs', const Color(0xFF00C7BE), ImageAssets.savedJob),
        ],
      ),
    );
  }
}
