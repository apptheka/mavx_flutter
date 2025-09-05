class AppConstants {
  static const String appName = "Mavx";

  // API URLs
  static const String baseUrl = 'http://192.168.1.14:3001/v1/api'; 
  static const String login = '/user/login';
  static const String register = '/user/register';
  static const String sendOtp = '/user/send-otp';
  static const String checkOtp = '/user/check-otp';
  static const String getAllSpecification = '/specialisation';
  static const String getAllIndustries = '/industries'; 
  static const String fileUploading = 'http://192.168.1.14:3001/file-uploading';
  static const String project = "/project";
  static const String projectSearch = "/project/search";
  static const String profile = "/profile/full";
  static const String user = "/user/user-profile";
  static const String bookmark = '/project/bookmark-project';
  static const String deleteBookmark = '/project/deleteBookmark';
  static const String getAllBookmark = '/project/getAllBookmark';
  static const String applyJob = '/user/apply-job';
  static const String getApplyJob = '/user/get-apply-job';
  static const String getUserApplyProjects = '/user/get-user-apply-projects';

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
