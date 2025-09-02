import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/core/constants/assets.dart';
import 'package:mavx_flutter/app/presentation/pages/login/login_controller.dart';
import 'package:mavx_flutter/app/presentation/theme/app_colors.dart';
import 'package:mavx_flutter/app/presentation/widgets/app_text_field.dart';
import 'package:mavx_flutter/app/presentation/widgets/common_text.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  // Inject controller once per page instance
  LoginController get controller => Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                _buildHeader(), 
                const SizedBox(height: 40),
                _buildForm(context), 
                const SizedBox(height: 32),
                _buildSignInButton(),
                const SizedBox(height: 24),
                _buildSocialSection(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          CommonText(
            'Welcome Back',
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
          CommonText(
            'Please sign in to continue',
            fontSize: 15,
            color: AppColors.textSecondaryColor,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText("Email or Phone", fontSize: 15, fontWeight: FontWeight.w600),
          const SizedBox(height: 8),
          AppTextField(
            onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
            controller: controller.emailController,
            validator: controller.validateEmailOrPhone,
            hintText: "Enter email or phone",
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: (value) => controller.emailController.text = value,
          ),
          const SizedBox(height: 20),
          CommonText("Password", fontSize: 15, fontWeight: FontWeight.w600),
          const SizedBox(height: 8),
          AppTextField(
            onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
            controller: controller.passwordController,
            validator: controller.validatePassword,
            hintText: "Enter your password",
            suffixIcon: const Icon(Icons.visibility_off,color: AppColors.textSecondaryColor,),
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            onChanged: (value) => controller.passwordController.text = value,
          ),
          const SizedBox(height: 16),
          _buildForgotPassword(),
        ],
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () {},
        child: const CommonText(
          'Forgot password?',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textButtonColor,
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return Column(
      children: [
        Obx(() => SizedBox(
              height: 56,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                  elevation: 0,
                ),
                onPressed: controller.isLoading.value ? null : controller.signIn,
                child: controller.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const CommonText(
                        'Sign In',
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
              ),
            )),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonText(
              'Don\'t have an account?',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondaryColor,
            ),
            const SizedBox(width: 5),
            InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.register);
              },
              child: CommonText(
                'Register Now',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textButtonColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialSection() {
    return Column(
      children: [
        const SizedBox(height: 8),
        const CommonText(
          'Or connect with',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondaryColor,
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialCircle(icon: IconAssets.google),
            const SizedBox(width: 24),
            _SocialCircle(icon: IconAssets.facebook),
            const SizedBox(width: 24),
            _SocialCircle(icon: IconAssets.linkedin),
          ],
        ),
      ],
    );
  }
}

class _SocialCircle extends StatelessWidget {
  final String icon;
  const _SocialCircle({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFF2F3F7),
      ),
      child: Image.asset(icon),
    );
  }
}