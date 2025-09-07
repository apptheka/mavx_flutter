class AppConstants {
  static const String appName = "Mavx";

  // API URLs
  static const String baseUrl = 'http://192.168.1.23:3001/v1/api'; 
  static const String baseUrlImage = 'http://192.168.1.23:3001/'; 
  static const String login = '/user/login';
  static const String register = '/user/register';
  static const String sendOtp = '/user/send-otp';
  static const String checkOtp = '/user/check-otp';
  static const String getAllSpecification = '/specialisation';
  static const String getAllIndustries = '/industries'; 
  static const String fileUploading = 'http://192.168.1.23:3001/file-uploading';
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
  static const String preferences = '/profile/preferences';
  static const String experience = '/profile/experience';
  static const String education = '/profile/education';
  static const String aboutMe = '/profile/about-me';
  static const String languages = '/profile/languages';
  static const String onlineProfiles = '/profile/online-profiles';
  static const String basicDetails = '/profile/basic-details';
  static const String skills = '/profile/skills';

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
