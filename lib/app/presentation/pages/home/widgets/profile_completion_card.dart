import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/image_assets.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';

class ProfileCompletionCard extends StatelessWidget {
  const ProfileCompletionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    return Obx(() {
      // If loading or any error (e.g., connection refused), don't show the card
      final isLoading = controller.loading.value;
      final hasError = controller.error.value.isNotEmpty;
      if (isLoading || hasError) return const SizedBox.shrink();

      final percent = controller.profileCompletion.value.clamp(0, 100);
      if (percent >= 100) return const SizedBox.shrink();

      return Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(16),
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
                children: [
                  Text(
                    'Your profile is $percent% complete',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0B2944),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: percent / 100.0,
                      minHeight: 8,
                      backgroundColor: Colors.black12,
                      valueColor: const AlwaysStoppedAnimation(Color(0xFF2F7CF6)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.profile),
                    child: const Text(
                      'Complete Profile',
                      style: TextStyle(
                        color: Color(0xFF2F7CF6),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
