import 'package:mavx_flutter/app/presentation/pages/change_password/change_pass_binding.dart';
import 'package:mavx_flutter/app/presentation/pages/change_password/change_pass_page.dart';
import 'package:mavx_flutter/app/presentation/pages/forget_password/forget_password_binding.dart';
import 'package:mavx_flutter/app/presentation/pages/forget_password/forget_password_page.dart';
import 'package:mavx_flutter/app/presentation/pages/my_projects/my_projects_binding.dart';
import 'package:mavx_flutter/app/presentation/pages/my_projects/my_projects_page.dart';
import 'package:mavx_flutter/app/presentation/pages/otp/otp_binding.dart';
import 'package:mavx_flutter/app/presentation/pages/otp/otp_page.dart';
import 'package:mavx_flutter/app/presentation/pages/requests/requests.binding.dart';
import 'package:mavx_flutter/app/presentation/pages/requests/requests_page.dart';
import 'package:mavx_flutter/app/presentation/pages/saved/saved_binding.dart';
import 'package:mavx_flutter/app/presentation/pages/saved/saved_page.dart';
import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/apply/apply_binding.dart';
import 'package:mavx_flutter/app/presentation/pages/apply/apply_page.dart';
import 'package:mavx_flutter/app/presentation/pages/dashboard/dashboard.dart';
import 'package:mavx_flutter/app/presentation/pages/dashboard/dashboard_binding.dart';
import 'package:mavx_flutter/app/presentation/pages/getStarted/get_started_binding.dart';
import 'package:mavx_flutter/app/presentation/pages/getStarted/get_started_page.dart';
import 'package:mavx_flutter/app/presentation/pages/home/home_binding.dart';
import 'package:mavx_flutter/app/presentation/pages/home/home_page.dart';
import 'package:mavx_flutter/app/presentation/pages/login/login_binding.dart';
import 'package:mavx_flutter/app/presentation/pages/login/login_page.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_binding.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_page.dart';
import 'package:mavx_flutter/app/presentation/pages/project_detail/project_detail_binding.dart';
import 'package:mavx_flutter/app/presentation/pages/project_detail/project_detail_page.dart';
import 'package:mavx_flutter/app/presentation/pages/register/register_binding.dart';
import 'package:mavx_flutter/app/presentation/pages/register/register_page.dart';
import 'package:mavx_flutter/app/presentation/pages/splash/splash_binding.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';
import 'package:mavx_flutter/app/presentation/pages/splash/splash_page.dart';
import 'package:mavx_flutter/app/presentation/pages/search/search_page.dart';
import 'package:mavx_flutter/app/presentation/pages/search/search_binding.dart';
import 'package:mavx_flutter/app/presentation/pages/notifications/notifications_page.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.getStarted,
      page: () => const GetStartedPage(),
      binding: GetStartedBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardPage(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.projectDetail,
      page: () => const ProjectDetailPage(),
      binding: ProjectDetailBinding(),
      arguments: Get.arguments,
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => const SearchPage(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
      arguments: Get.arguments,
    ),
    GetPage(
      name: AppRoutes.saved,
      page: () => const SavedPage(),
      binding: SavedBinding(),
    ),
    GetPage(
      name: AppRoutes.apply,
      page: () => const ApplyPage(),
      binding: ApplyBinding(),
    ),
    GetPage(
      name: AppRoutes.requests,
      page: () => const RequestsPage(),
      binding: RequestsBinding(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsPage(),
    ),
    GetPage(
      name: AppRoutes.forgetPassword,
      page: () => const ForgetPasswordPage(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () => const OtpPage(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: AppRoutes.changePassword,
      page: () => const ChangePassPage(),
      binding: ChangePassBinding(),
      arguments: Get.arguments,
    ),
    GetPage(
      name: AppRoutes.myProject,
      page: () => const MyProjectsPage(),
      binding: MyProjectsBinding(),
    ),
  ];
}
