import 'package:flutter/material.dart';
import 'package:mavx_flutter/app/core/constants/image_assets.dart';

class ProfileCompletionCard extends StatelessWidget {
  const ProfileCompletionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(ImageAssets.userAvatar),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Your profile is 78% complete',
                  style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0B2944)),
                ),
                SizedBox(height: 4),
                Text(
                  'Complete Profile',
                  style: TextStyle(color: Color(0xFF2F7CF6), fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
