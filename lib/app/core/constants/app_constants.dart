class AppConstants {
  static const String appName = "Mavx";

  // API URLs
  static const String baseUrl = 'https://apis.apptheka.com/mavx/v1/api';
  // static const String baseUrl = 'http://192.168.1.3:3001/v1/api';
  static const String baseUrlImage = 'https://apis.apptheka.com/mavx/public/';
  static const String fileUploading = 'https://apis.apptheka.com/mavx/file-uploading';
  // Timesheet endpoint for insert - local development server
  static const String login = '/user/login';
  static const String register = '/user/register';
  static const String sendOtp = '/user/send-otp';
  static const String checkOtp = '/user/check-otp';
  static const String changePassword = '/user/change-password';
  static const String getAllSpecification = '/specialisation';
  static const String getAllIndustries = '/industries';
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
  static const String request = '/user/expert-requests';
  static const String fcmRegister = '/notifications/device/register';
  static const String fcmUnregister = '/notifications/:id';
  // static const String topicSubscribe = '/notifications/topic/subscribe';
  static const String myProjects = '/user/expert-hires?status=confirmed';
  static const String timesheet = '/timesheet/upsert';
  static const String getTimesheet = '/timesheet/project/{projectId}/expert/{expertId}';
  static const String invoice = '/invoice';
  static const String bankDetails = '/profile/bank-details';
  static const String getExpenses= '/expenses/project/{projectId}/expert/{expertId}';
  static const String upsertExpenses = '/expenses/upsert';
  static const String notificationsList = '/notifications/list';
  static const String sendEmail = '/email/send';

  // Google Sign-In Web client ID (from google-services.json client_type=3)
  static const String googleServerClientId = '961866680814-op3u2p4ivdh8tvf5g8k50chqbqm5qvbu.apps.googleusercontent.com';

  // LinkedIn OAuth config (set these from your LinkedIn Developer App)
  static const String linkedinClientId = '862grndqzp05go'; 
  // static const String linkedinClientSecret = 'WPL_AP1.wB6AUDiP8bZQAttk.ldM5TA=='; 
  static const String linkedinRedirectUrl = 'https://mavxexpert.web.app/login';

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


class HiveConstant {
  static const String CACHE = 'CACHE'; 
  static const String APP_BOX = "APP_BOX"; 
}

class HiveFieldConstant {
  static const String DEVICE_ID = "DEVICE_ID";
  static const String FCM_TOKEN = "FCM_TOKEN";
}

