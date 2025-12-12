import 'dart:io'; 
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mavx_flutter/app/core/constants/app_constants.dart'; 
import 'package:mavx_flutter/app/core/services/notification_storage_service.dart';
import 'package:mavx_flutter/app/core/services/storage_service.dart';
import 'package:mavx_flutter/app/di/dependence_injection.dart';
import 'package:mavx_flutter/app/presentation/theme/app_theme.dart';
import 'package:mavx_flutter/app/routes/app_pages.dart';
import 'package:mavx_flutter/firebase_options.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Ensure Flutter engine & platform channels are initialized
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationStorageService.init();
  await _initializeHive();
 
  
  // Initialize storage
  final storage = StorageService();
  await storage.init();

  // Initialize dependencies
  await DependenceInjection.init();
    await Firebase.initializeApp();   // ✔ REQUIRED
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

Future<void> _initializeHive() async {
  try {
    Directory directory = await pathProvider.getApplicationDocumentsDirectory();
    await Hive.initFlutter(directory.path);

    // Open all required boxes
    final boxes = [HiveConstant.CACHE];

    for (final boxName in boxes) {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox(boxName);
      }
    }
  } catch (e) {
    rethrow;
  }
}
