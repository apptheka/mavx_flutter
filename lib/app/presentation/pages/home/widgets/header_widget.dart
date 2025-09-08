import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';
import 'package:mavx_flutter/app/core/constants/image_assets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mavx_flutter/app/presentation/pages/home/home_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/home/widgets/search_bar_widget.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';

class HeaderWidget extends GetView<HomeController> {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () => Get.toNamed(AppRoutes.requests),
                child: Image.asset(
                  IconAssets.dashboard,
                  color: Colors.white,
                  height: 25,
                  width: 25,
                ),
              ),
              const SizedBox(width: 5),
              SearchBarIcon(onTap: () => Get.toNamed(AppRoutes.search)),
              IconButton(
                onPressed: () {},
                icon: Image.asset(
                  IconAssets.notification,
                  height: 25,
                  width: 25,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
