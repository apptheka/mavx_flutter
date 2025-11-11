import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/image_assets.dart';
import 'package:mavx_flutter/app/presentation/pages/home/home_controller.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';

class StatsRow extends StatelessWidget {
  final HomeController controller;
  final EdgeInsetsGeometry padding;
   const StatsRow({super.key, this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 8), required this.controller});

  Widget _statBox(String value, String label, Color color, String image) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonText(value, fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black),
                const SizedBox(height: 4),
                CommonText(
                  label,
                  color: Colors.black54, 
                  fontWeight: FontWeight.w600,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 12,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Image.asset(
            image,
            fit: BoxFit.contain,
            width: 36,
            height: 36,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(child: Obx(() => InkWell(
            onTap: () => Get.toNamed(AppRoutes.saved),
            child: _statBox(
              controller.totalBookmarks.value.toString(),
              'Saved Jobs',
              const Color(0xFF00C7BE),
              ImageAssets.savedJob,
            ),
          ))),
        ],
      ),
    );
  }
}
