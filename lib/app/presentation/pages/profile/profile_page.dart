import 'package:flutter/material.dart';
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

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Container(height: topInset, color: const Color(0xFF0B2944)),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ProfileHeader(),
                  SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfilePreferences(),
                      ProfileResume(),
                      ProfileAbout(),
                      ProfileSkills(),
                      ProfileExperience(),
                      ProfileEducation(),
                      ProfileLanguages(),
                      ProfileOnlineProfiles(),
                      ProfileBasicDetails(),
                      SizedBox(height: 24),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
