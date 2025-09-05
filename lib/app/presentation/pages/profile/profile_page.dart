import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/profile_header.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/profile_preferences.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/profile_resume.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/profile_about.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/profile_skills.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/profile_experience.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/profile_education.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/profile_languages.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/profile_online_profiles.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/widgets/profile_basic_details.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/pages/home/widgets/profile_completion_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.find<ProfileController>();
    final topInset = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Container(height: topInset, color: const Color(0xFF0B2944)),
          SafeArea(
            child: Obx(() {
              // Touch reactive sources to rebuild when data loads
              final isLoading = controller.loading.value;
              final error = controller.error.value;
              if (isLoading) {
                return const Center(
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(strokeWidth: 2.8, color: Color(0xFF0B2944)),
                  ),
                );
              }
              if (error.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(error, style: const TextStyle(color: Colors.red)),
                  ),
                );
              }
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileHeader(controller:  controller,),
                    const SizedBox(height: 16),
                    // Profile completion indicator (auto-hides at 100%)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ProfileCompletionCard(),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfilePreferences(controller: controller),
                        ProfileResume(controller: controller),
                        ProfileAbout(controller: controller),
                        ProfileSkills(controller: controller),
                        ProfileExperience(controller: controller),
                        ProfileEducation(controller: controller),
                        ProfileLanguages(controller: controller),
                        ProfileOnlineProfiles(controller: controller),
                        ProfileBasicDetails(controller: controller),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
