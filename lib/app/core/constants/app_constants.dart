class AppConstants {
  static const String appName = "Mavx";

  // API URLs
  static const String baseUrl = 'http://192.168.1.30:3001/v1/api';
  // Absolute endpoint for encryption (outside baseUrl)
  static const String encryptUrl = 'http://192.168.1.30:3001/encrypt';
  static const String login = '/user/login';
  static const String register = '/user/register';
  static const String sendOtp = '/user/send-otp';
  static const String checkOtp = '/user/check-otp';

  // Storage Keys
  static const String tokenKey = 'token';
  static const String userKey = 'user';
  static const String isLoggedInKey = 'isLoggedIn';

  // Routes 
  static const String initialRoute = '/splash';
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
  static const String dashboardRoute = '/dashboard';
  static const String profileRoute = '/profile';
}
