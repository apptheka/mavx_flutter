import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart';
import 'package:mavx_flutter/app/presentation/theme/app_theme.dart';
import 'package:mavx_flutter/app/routes/app_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( 
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.fade,
    );
  }
}
 