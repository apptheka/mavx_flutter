

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';
import 'package:mavx_flutter/app/presentation/pages/home/home_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/project_detail/project_detail_controller.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';

class DetailHeader extends StatelessWidget {
  const DetailHeader({super.key, required this.isConfirmed});
  final bool isConfirmed;

  @override
  Widget build(BuildContext context) {
    // Use HomeController as the single source of truth for bookmarks
    final homeCtrl = Get.find<HomeController>();
    final int projectId = Get.arguments is int ? Get.arguments as int : 0;
    
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF103A5C), Color(0xFF0B2944)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Back button
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: CommonText(
              'Project Details',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ), 
          Obx(() {
            final isApplied = ProjectDetailController().appliedIds.contains(projectId);
            final isBookmarked = homeCtrl.bookmarkedIds.contains(projectId);
            if(isApplied){
              return const SizedBox.shrink();
            }
            return Row(
              children: [
                if(!isConfirmed)
                IconButton(
                  onPressed: () {
                    homeCtrl.toggleBookmark(projectId);
                  },
                  icon: isBookmarked ? Image.asset(
                    IconAssets.saved,
                    height: 20,
                    width: 20,
                    color: Colors.white,
                  ) : Image.asset(
                    IconAssets.clipboard,
                    height: 20,
                    width: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}