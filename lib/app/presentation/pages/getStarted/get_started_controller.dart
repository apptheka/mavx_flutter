import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/services/storage_service.dart';
import 'package:mavx_flutter/app/core/constants/image_assets.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';

class OnboardItem {
  final String image;
  final String eyebrow;
  final String title;
  final String body;
  final String cta;

  const OnboardItem({
    required this.image,
    required this.eyebrow,
    required this.title,
    required this.body,
    required this.cta,
  });
}

class GetStartedController extends GetxController {
  final PageController pageController = PageController();
  final StorageService storage = Get.find<StorageService>();

  final RxInt current = 0.obs;

  final List<OnboardItem> items = const [
    OnboardItem(
      image: ImageAssets.getStarted1,
      eyebrow: 'Welcome to MavX',
      title: 'Where experience meets\nopportunity.',
      body: 'Join an exclusive network of experts and get matched with high-value projects tailored to your skills.',
      cta: 'Get Started',
    ),
    OnboardItem(
      image: ImageAssets.getStarted2,
      eyebrow: 'Only the Right Work',
      title: 'Get matched with\nmeaningful projects.',
      body: 'We use smart matching to connect you with projects that fit your expertise, availability, and interests.',
      cta: 'Next',
    ),
    OnboardItem(
      image: ImageAssets.getStarted3,
      eyebrow: 'You\'ve Earned it',
      title: 'A platform that respects\nyour time and talent.',
      body: 'No spam. No junior roles. Just curated, high-quality work for proven professionals like you.',
      cta: 'Next',
    ),
    OnboardItem(
      image: ImageAssets.getStarted4,
      eyebrow: 'Let\'s Get Started',
      title: 'Ready to Discover\nProjects?',
      body: 'Tell us about your skills and experience to unlock tailored project matches.',
      cta: 'Get Started',
    ),
  ];

  bool get isLast => current.value == items.length - 1;

  void onPageChanged(int index) {
    current.value = index;
  }

  void next() {
    if (!isLast) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      // Mark onboarding as seen and navigate to login
      try {
        storage.prefs.setBool('onboarding_seen', true); 
      } catch (_) { 
      }
      Get.offAllNamed(AppRoutes.login);
    }
  }

  void prev() {
    if (current.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void skipToLast() {
      try {
        storage.prefs.setBool('onboarding_seen', true);
      } catch (_) {}
      Get.offNamed(AppRoutes.login);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}