import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/home/home_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/home/home_page.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/search/search_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/search/search_page.dart';
import 'package:mavx_flutter/app/presentation/pages/applications/applications_page.dart';
import 'package:mavx_flutter/app/presentation/pages/applications/applications_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_page.dart';
import 'package:mavx_flutter/app/presentation/pages/dashboard/dashboard_controller.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = const [
      HomePage(),
      SearchPage(),
      ApplicationsPage(),
      ProfilePage(),
    ];

    return Obx(() {
      final idx = controller.currentIndex.value;
      return PopScope(
        canPop: idx == 0,
        onPopInvokedWithResult: (didPop, result) {
          // If not on Home tab, consume back and switch to Home (index 0)
          if (!didPop && idx != 0) {
            controller.changeTab(0);
          }
        },
        child: Scaffold( 
        backgroundColor: AppColors.backgroundColor,
        body: IndexedStack(
          index: idx,
          children: pages,
        ),
        bottomNavigationBar: _BottomBar(
          currentIndex: idx,
          onTap: (i) {
            // If Applications tab tapped, refresh its data
            if (i == 0) {
              if (Get.isRegistered<HomePage>()) {
                // no-op: widget class, keep for clarity
              }
              if (Get.isRegistered<HomeController>()) {
                Get.find<HomeController>().fetchProjects();
              }
            } 
            if (i == 1) {
              if (Get.isRegistered<SearchPage>()) {
                // no-op: widget class, keep for clarity
              }
              if (Get.isRegistered<SearchPageController>()) {
                Get.find<SearchPageController>().refresh();
              }
            } 
            if (i == 2) {
              if (Get.isRegistered<ApplicationsPage>()) {
                // no-op: widget class, keep for clarity
              }
              if (Get.isRegistered<ApplicationsController>()) {
                Get.find<ApplicationsController>().fetchData();
              }
            } 
            if (i == 3) {
              if (Get.isRegistered<ProfilePage>()) {
                // no-op: widget class, keep for clarity
              }
              if (Get.isRegistered<ProfileController>()) {
                Get.find<ProfileController>().fetchProfile();
              }
            }
            controller.changeTab(i);
          },
        ),
      ),
      );
    });
  }
}

class _BottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const _BottomBar({required this.currentIndex, required this.onTap});

  BottomNavigationBarItem _item(String asset, String label) {
    return BottomNavigationBarItem(

      icon: ImageIcon(AssetImage(asset),),
      activeIcon: ImageIcon(AssetImage(asset)),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container( 
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BottomNavigationBar( 
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          currentIndex: currentIndex,
          onTap: onTap,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: AppColors.secondaryColor,
          unselectedItemColor: const Color(0xFF7D8A97),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: [
            _item(IconAssets.home, 'Home'),
            _item(IconAssets.search, 'Search'),
            _item(IconAssets.application, 'Applied'),
            _item(IconAssets.profile, 'Profile'),
          ],
        ),
      ),
    );
  }
}