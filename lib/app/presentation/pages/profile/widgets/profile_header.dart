import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';
import 'package:mavx_flutter/app/core/constants/image_assets.dart';
import 'package:mavx_flutter/app/domain/repositories/auth_repository.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileController controller;
  const ProfileHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = Get.find<AuthRepository>();
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
                    child: Text(
                      'My Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      authRepository.logout();
                      Get.snackbar(
                        "Logout",
                        "You have been logged out",
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      Get.offAllNamed(AppRoutes.login);
                    },
                    icon: Image.asset(
                      IconAssets.logout,
                      height: 20,
                      width: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: ClipOval(
                      child: Image.asset(
                        ImageAssets.userAvatar,
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _NameAndStatus(controller: controller)),
                ],
              ),
              const SizedBox(height: 12),
              Container(height: 1, color: Colors.white24),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    _IconText(
                      iconAsset: IconAssets.experience,
                      text: '${controller.registeredProfile.value.experience} Years of experience',
                    ),
                    SizedBox(width: 18),
                    _IconText(
                      iconAsset: IconAssets.location,
                      text: '${controller.registeredProfile.value.location}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ), 
      ],
    );
  }
}

class _NameAndStatus extends StatelessWidget {
  final ProfileController controller;
  const _NameAndStatus({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Obx(() {
              final rp = controller.registeredProfile.value;
              final first = (rp.fullName ?? '').trim();
              final last = (rp.lastName ?? '').trim();
              final hasAny = first.isNotEmpty || last.isNotEmpty;
              final displayName = hasAny
                  ? [first, last].where((s) => s.isNotEmpty).join(' ')
                  : 'Your Name';
              return CommonText(
                displayName,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              );
            }),
            const Spacer(),
            Image.asset(
              IconAssets.edit,
              height: 20,
              width: 20,
              color: Colors.white,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Obx(
          () => Row(
            children: [
              Image.asset(IconAssets.role, height: 15, width: 15),
              const SizedBox(width: 8),
              CommonText(
                '${controller.preferences.value.lookingFor}'.replaceAll("1", ""),
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ],
          ),
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
