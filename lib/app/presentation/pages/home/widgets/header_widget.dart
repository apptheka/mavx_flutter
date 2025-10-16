import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';
import 'package:mavx_flutter/app/core/constants/image_assets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mavx_flutter/app/presentation/pages/home/home_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/home/widgets/search_bar_widget.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:mavx_flutter/app/presentation/pages/requests/requests_badge_controller.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';
import 'package:mavx_flutter/app/core/services/notification_storage_service.dart';

class HeaderWidget extends GetView<HomeController> {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                final avatar = controller.avatarUrl; // full http(s) if valid
                final rawProfilePath = controller.user.value?.profile.trim();
                String? url;
                if (avatar != null && avatar.isNotEmpty) {
                  url = avatar;
                } else if (rawProfilePath != null &&
                    rawProfilePath.isNotEmpty &&
                    rawProfilePath.toLowerCase() != 'null') {
                  url = "${AppConstants.baseUrlImage}$rawProfilePath";
                }

                return GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.profile),
                  child: CircleAvatar(
                    radius: 20,
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
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              placeholderBuilder: (_) =>
                                  Image.asset(ImageAssets.userAvatar),
                            ),
                          );
                        } 
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                );
              }),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonText(
                        "${controller.greeting.value}, ${controller.user.value?.fullName.capitalizeFirst}",
                        color: Colors.white70,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const  SizedBox(height: 2),
                      CommonText(
                        "Home",
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              GetX<RequestsBadgeController>(
                init: RequestsBadgeController(),
                builder: (reqBadge) {
                  return InkWell(
                    onTap: () async {
                      await Get.toNamed(AppRoutes.requests);
                      // Refresh pending count when returning
                      reqBadge.fetchPending();
                    },
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset(
                          IconAssets.requests,
                          color: Colors.white,
                          height: 22,
                          width: 22,
                        ),
                        if (reqBadge.pendingCount.value > 0)
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 1),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(width: 5),
              SearchBarIcon(onTap: () => Get.toNamed(AppRoutes.search)),
              // Notifications icon with live unread badge
              (() {
                final listenable = NotificationStorageService.listenable();
                Widget buildIconWithCount(int count) {
                  return InkWell(
                    onTap: () => Get.toNamed(AppRoutes.notifications),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset(
                          IconAssets.notification,
                          height: 22,
                          width: 22,
                          color: Colors.white,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.notifications,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        if (count > 0)
                          Positioned(
                            right: -4,
                            top: -4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white, width: 1),
                              ),
                              constraints: const BoxConstraints(minWidth: 18, minHeight: 16),
                              child: CommonText(
                                count > 99 ? '99+' : '$count',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }

                if (listenable == null) {
                  // Fallback: render without live updates
                  final count = NotificationStorageService.unreadCount(); 
                  return buildIconWithCount(count);
                }

                return ValueListenableBuilder(
                  valueListenable: listenable,
                  builder: (context, box, _) {
                    final count = NotificationStorageService.unreadCount();
                    return buildIconWithCount(count);
                  },
                );
              })(),
            ],
          ),
        ],
      ),
    );
  }
}
