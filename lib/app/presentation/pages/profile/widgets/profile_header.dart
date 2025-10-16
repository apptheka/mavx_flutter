import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';
import 'package:mavx_flutter/app/core/constants/image_assets.dart';
import 'package:mavx_flutter/app/domain/repositories/auth_repository.dart';
import 'package:mavx_flutter/app/presentation/pages/home/home_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileController controller;
  const ProfileHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = Get.find<AuthRepository>();
    final HomeController homeController = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0B2944), Color(0xFF103A5C), Color(0xFF103A5C)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: CommonText(
                      'My Profile',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await _logoutDialog(authRepository);
                    },
                    icon: Image.asset(
                      IconAssets.logout,
                      height: 18,
                      width: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() {
                    final avatar =
                        homeController.avatarUrl; // full http(s) if valid
                    final rawProfilePath = homeController.user.value?.profile
                        .trim();
                    String? url;
                    if (avatar != null && avatar.isNotEmpty) {
                      url = avatar;
                    } else if (rawProfilePath != null &&
                        rawProfilePath.isNotEmpty &&
                        rawProfilePath.toLowerCase() != 'null') {
                      url = "${AppConstants.baseUrlImage}$rawProfilePath";
                    }

                    return CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      backgroundImage:
                          (url != null && !url.toLowerCase().endsWith('.svg'))
                          ? NetworkImage(url)
                          : null,
                      child: Builder(
                        builder: (context) {
                          if (url == null || url.isEmpty) {
                            return Image.asset(ImageAssets.userAvatar);
                          }
                          if (url.toLowerCase().endsWith('.svg')) {
                            return ClipOval(
                              child: SvgPicture.network(
                                url,
                                width: 46,
                                height: 46,
                                fit: BoxFit.cover,
                                placeholderBuilder: (_) =>
                                    Image.asset(ImageAssets.userAvatar),
                              ),
                            );
                          }
                          // For raster images, child remains null to show backgroundImage
                          return const SizedBox.shrink();
                        },
                      ),
                    );
                  }),
                  const SizedBox(width: 12),
                  Expanded(child: _NameAndStatus(controller: controller)),
                ],
              ),
              const SizedBox(height: 12),
              Container(height: 1, color: Colors.white24),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Obx(() {
                  final rp = controller.registeredProfile.value;
                  final expText = (rp.experience != null)
                      ? '${rp.experience} Years of experience'
                      : 'Years of experience';
                  final locText =
                      (rp.location != null && rp.location!.trim().isNotEmpty)
                      ? rp.location!.trim()
                      : 'Location';
                  return Row(
                    children: [
                      _IconText(
                        iconAsset: IconAssets.experience,
                        text: expText,
                      ),
                      const SizedBox(width: 18),
                      _IconText(iconAsset: IconAssets.location, text: locText),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _logoutDialog(AuthRepository authRepository) async {
    return Get.dialog(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: const EdgeInsets.all(24),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.red.shade600,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const CommonText(
                'Logout',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              CommonText(
                'Are you sure you want to logout?',
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
              const SizedBox(height: 4),
              CommonText(
                'You will need to login again to access your account.',
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                    child: const CommonText(
                      'Cancel',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      authRepository.logout();
                      Get.snackbar(
                        'Logout',
                        'You have been logged out successfully',
                        duration: const Duration(seconds: 3),
                        icon: const Icon(
                          Icons.check_circle_outline,
                          color: Colors.white,
                          size: 28,
                        ),
                        colorText: Colors.white,
                        backgroundColor: Colors.green.shade600,
                        snackPosition: SnackPosition.BOTTOM,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                        animationDuration: const Duration(milliseconds: 300),
                      );
                      Get.offAllNamed(AppRoutes.login);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const CommonText(
                      'Logout',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
          actionsPadding: const EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: 20,
            top: 8,
          ),
        ),
      ));
    }
}


class _NameAndStatus extends StatelessWidget {
  final ProfileController controller;
    _NameAndStatus({required this.controller});
  
  final AuthRepository authRepository = Get.find<AuthRepository>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Obx(() {
              final rp = controller.registeredProfile.value;
              final first = (rp.fullName?.trim().capitalizeFirst ?? '').trim();
              final last = (rp.lastName?.trim().capitalizeFirst ?? '').trim();
              final hasAny = first.isNotEmpty || last.isNotEmpty;
              final displayName = hasAny
                  ? [first, last].where((s) => s.isNotEmpty).join(' ')
                  : 'Your Name';
              return CommonText(
                displayName,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              );
            }),
            const Spacer(),
            
            IconButton(
              onPressed: () {
                Get.toNamed(AppRoutes.myProject);
              },
              icon: Image.asset(
                IconAssets.role,
                height: 20,
                width: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _IconText extends StatelessWidget {
  final String iconAsset;
  final String text;
  const _IconText({required this.iconAsset, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(iconAsset, height: 18, width: 18, color: Colors.white),
        const SizedBox(width: 8),
        CommonText(
          text,
          color: Colors.white.withOpacity(0.9),
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
