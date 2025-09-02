import 'package:get/get.dart';
import 'package:mavx_flutter/app/presentation/pages/getStarted/get_started_binding.dart';
import 'package:mavx_flutter/app/presentation/pages/getStarted/get_started_page.dart';
import 'package:mavx_flutter/app/presentation/pages/home/home_binding.dart';
import 'package:mavx_flutter/app/presentation/pages/home/home_page.dart';
import 'package:mavx_flutter/app/presentation/pages/login/login_binding.dart';
import 'package:mavx_flutter/app/presentation/pages/login/login_page.dart';
import 'package:mavx_flutter/app/presentation/pages/register/register_binding.dart';
import 'package:mavx_flutter/app/presentation/pages/register/register_page.dart';
import 'package:mavx_flutter/app/presentation/pages/splash/splash_binding.dart';
import 'package:mavx_flutter/app/routes/app_routes.dart';
import 'package:mavx_flutter/app/presentation/pages/splash/splash_page.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(name: AppRoutes.splash, page: () => const SplashPage(), binding: SplashBinding()),
    GetPage(name: AppRoutes.getStarted, page: () => const GetStartedPage(),binding: GetStartedBinding()),
    GetPage(name: AppRoutes.login, page: () => const LoginPage(), binding: LoginBinding()),
    GetPage(name: AppRoutes.home, page: () => const HomePage(), binding: HomeBinding()),
    GetPage(name: AppRoutes.register, page: () => const RegisterPage(), binding: RegisterBinding()),
  ];
}
