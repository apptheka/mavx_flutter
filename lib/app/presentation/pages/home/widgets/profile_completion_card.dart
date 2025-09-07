import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/constants/image_assets.dart';
import 'package:mavx_flutter/app/presentation/pages/home/home_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';

class ProfileCompletionCard extends StatelessWidget {
  const ProfileCompletionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());
    final homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());

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
          color: AppColors.black.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             // Avatar with circular completion ring
             Obx(() {
               final avatar = homeController.avatarUrl; // full http(s) if valid
               final rawProfilePath = homeController.user.value?.profile.trim();
               String? url;
               if (avatar != null && avatar.isNotEmpty) {
                 url = avatar;
               } else if (rawProfilePath != null &&
                   rawProfilePath.isNotEmpty &&
                   rawProfilePath.toLowerCase() != 'null') {
                 url = "${AppConstants.baseUrlImage}$rawProfilePath";
               }

               final progress = (percent / 100.0).clamp(0.0, 1.0);
               const ringSize = 50.0; // outer ring diameter
               const avatarRadius = 22.5; // inner avatar radius

               Widget avatarWidget = CircleAvatar(
                 radius: avatarRadius,
                 backgroundColor: Colors.white.withValues(alpha: 0.2),
                 backgroundImage: (url != null && !url.toLowerCase().endsWith('.svg'))
                     ? NetworkImage(url)
                     : null,
                 child: Builder(builder: (context) {  
                   if (url == null || url.isEmpty) {
                     return Image.asset(ImageAssets.userAvatar);
                   }
                   if (url.toLowerCase().endsWith('.svg')) {
                     return ClipOval(
                       child: SvgPicture.network(
                         url,
                         width: avatarRadius * 3,
                         height: avatarRadius * 3,
                         fit: BoxFit.cover,
                         placeholderBuilder: (_) => Image.asset(ImageAssets.userAvatar),
                       ),
                     );
                   }
                   // For raster images, child remains null to show backgroundImage
                   return const SizedBox.shrink();
                 }),
               );

               return GestureDetector(
                 onTap: () => Get.toNamed(AppRoutes.profile),
                 child: SizedBox(
                   width: ringSize,
                   height: ringSize,
                   child: Stack(
                     alignment: Alignment.center,
                     children: [
                       // Background ring
                       SizedBox(
                         width: ringSize,
                         height: ringSize,
                         child: CircularProgressIndicator(
                           value: 1,
                           strokeWidth: 4,
                           valueColor: AlwaysStoppedAnimation<Color>(Colors.black12),
                         ),
                       ),
                       // Foreground ring for completion
                       SizedBox(
                         width: ringSize,
                         height: ringSize,
                         child: CircularProgressIndicator(
                           value: progress,
                           strokeWidth: 4,
                           backgroundColor: Colors.transparent,
                           valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF33C481)),
                         ),
                       ),
                       // Avatar in center
                       avatarWidget,
                     ],
                   ),
                 ),
               );
             }),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText(
                    'Your profile is $percent% complete',
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF0B2944),
                  ),  
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.profile),
                    child: CommonText(
                      'Complete Profile',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textButtonColor,
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
