import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mavx_flutter/app/core/services/notification_storage_service.dart';
import 'package:mavx_flutter/firebase_options.dart'; 

class FirebaseMessagingService {
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  String? _fcmToken;
  bool _isInitialized = false;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AndroidNotificationChannel _channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // name
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  /// Initialize Firebase Messaging service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Request notification permissions
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
      );

      print(
          '📱 Notification permission status: ${settings.authorizationStatus}');

      // Initialize local notifications
      await _initializeLocalNotifications(); // ✅ Add this

      // iOS: show notifications while in foreground as banners
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Set up message handlers
      FirebaseMessaging.onMessage.listen(_onForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Get FCM token
      await _getFCMTokenWithRetry();

      _isInitialized = true;
    } catch (e) {
      print('❌ Error initializing Firebase Messaging: $e');
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotificationsPlugin.initialize(initializationSettings);

    // Create the notification channel
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  /// Get FCM token with retry logic for iOS
  Future<String?> _getFCMTokenWithRetry() async {
    const int maxRetries = 3;
    const Duration retryDelay = Duration(seconds: 2);

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        String? token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          _fcmToken = token;
          print('📱 FCM Token obtained successfully: $token');
          return token;
        }
      } catch (e) {
        print('❌ Error getting FCM token (attempt $attempt): $e');

        if (Platform.isIOS) {
          print('📱 iOS detected - APNS token might not be available yet');
          if (attempt < maxRetries) {
            print('⏳ Retrying in ${retryDelay.inSeconds} seconds...');
            await Future.delayed(retryDelay);
          }
        } else {
          // For non-iOS platforms, don't retry
          break;
        }
      }
    }

    print('❌ Failed to get FCM token after $maxRetries attempts');
    return null;
  }

  /// Get the current FCM token
  String? get fcmToken => _fcmToken;

  /// Refresh FCM token
  Future<String?> refreshToken() async {
    return await _getFCMTokenWithRetry();
  }

  /// Handle foreground messages
void _onForegroundMessage(RemoteMessage message) async {
  print("🔥 Foreground message received: ${message.data}");
  print("📩 Full message: ${message.toMap()}");

  final notification = message.notification;
  final android = notification?.android;

  if (notification != null && android != null) {
    // Standard case (payload has notification)
    _localNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  } else if (message.data.isNotEmpty) {
    // Data-only case (you need to show manually)
    _localNotificationsPlugin.show(
      message.hashCode,
      message.data['title'] ?? 'New message',
      message.data['body'] ?? 'You have a new notification',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }

  // Persist to Hive
  try {
    await NotificationStorageService.saveFromRemoteMessage(message);
  } catch (e) {
    print('❌ Failed to persist notification: $e');
  }
}


  /// Handle when app is opened from notification
  void _onMessageOpenedApp(RemoteMessage message) {
    print('🔔 App opened from notification: ${message.notification?.title}');
    print('📝 Message data: ${message.data}');

    // Handle navigation based on message data
    // You can use Get.toNamed() or other navigation methods here
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
      print('📱 Subscribed to topic: $topic');
    } catch (e) {
      print('❌ Error subscribing to topic $topic: $e');
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
      print('📱 Unsubscribed from topic: $topic');
    } catch (e) {
      print('❌ Error unsubscribing from topic $topic: $e');
    }
  }
}

// Top-level background message handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    // Ensure Firebase is initialized in the background isolate
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (_) {}

  // Ensure Hive is ready and persist the message
  try {
    await NotificationStorageService.init();
    await NotificationStorageService.saveFromRemoteMessage(message);
  } catch (e) {
    // Log but don't crash
    // ignore: avoid_print
    print('❌ BG handler persist failed: $e');
  }
}
