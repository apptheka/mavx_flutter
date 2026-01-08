import 'package:get/get.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart'
    show ApiProvider;
import 'package:mavx_flutter/app/data/repositories/apply_job_repository_impl.dart';
import 'package:mavx_flutter/app/data/repositories/auth_repository_impl.dart';
import 'package:mavx_flutter/app/data/repositories/bank_details_repository_impl.dart';
import 'package:mavx_flutter/app/data/repositories/bookmark_repository_impl.dart';
import 'package:mavx_flutter/app/data/repositories/industries_repository_impl.dart';
import 'package:mavx_flutter/app/data/repositories/my_projects_repository_impl.dart';
import 'package:mavx_flutter/app/data/repositories/profile_repository_impl.dart';
import 'package:mavx_flutter/app/data/repositories/projects_repository_impl.dart';
import 'package:mavx_flutter/app/data/repositories/request_respository_impl.dart';
import 'package:mavx_flutter/app/data/repositories/specification_repository_impl.dart';
import 'package:mavx_flutter/app/data/repositories/file_repository_impl.dart';
import 'package:mavx_flutter/app/domain/repositories/apply_job_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/auth_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/bank_details_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/bookmarks_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/industries_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/my_project_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/profile_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/projects_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/request_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/specification_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/file_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/notification_repository.dart';
import 'package:mavx_flutter/app/data/repositories/notification_repository_impl.dart';
import 'package:mavx_flutter/app/domain/repositories/email_repository.dart';
import 'package:mavx_flutter/app/data/repositories/email_repository_impl.dart';
import 'package:mavx_flutter/app/domain/usecases/bank_details_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/bookmark_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/delete_bookmark_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/get_all_bookmarks_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/check_auth_status_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/get_all_industries_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/get_all_specification_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/login_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/my_project_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/profile_usecases.dart';
import 'package:mavx_flutter/app/domain/usecases/projects_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/register_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/requests_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/upload_file_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/email_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/apply_job_usecase.dart';
import 'package:mavx_flutter/app/core/services/storage_service.dart';
import 'package:mavx_flutter/app/presentation/pages/applications/applications_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/apply/apply_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/chat/chat_badge_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/chat/chat_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/change_password/change_pass_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/dashboard/dashboard_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/forget_password/forget_password_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/getStarted/get_started_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/home/home_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/login/login_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/my_projects/my_projects_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/notifications/notifications_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/otp/otp_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/project_detail/project_detail_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/register/register_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/requests/requests_badge_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/requests/requests_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/saved/saved_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/search/search_controller.dart';
import 'package:mavx_flutter/app/presentation/pages/splash/splash_controller.dart';

class DependenceInjection {
  static Future<void> init() async {
    // Initialize storage once at startup and register the initialized instance
    final storage = StorageService();
    await storage.init();
    Get.put<StorageService>(storage);

    // Core providers/repositories should be recreatable after disposal
    Get.lazyPut(() => ApiProvider(), fenix: true);

    //controller
    Get.lazyPut(() => ProfileController(), fenix: true);

    //repositories
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(), fenix: true);
    Get.lazyPut<SpecificationRepository>(() => SpecificationRepositoryImpl(), fenix: true);
    Get.lazyPut<IndustriesRepository>(() => IndustriesRepositoryImpl(), fenix: true);
    Get.lazyPut<FileRepository>(() => FileRepositoryImpl(), fenix: true);
    Get.lazyPut<ProjectsRepository>(() => ProjectsRepositoryImpl(), fenix: true);
    Get.lazyPut<ProfileRepositoryImpl>(() => ProfileRepositoryImpl(), fenix: true);
    Get.lazyPut<ProfileRepository>(() => Get.find<ProfileRepositoryImpl>(), fenix: true);
    Get.lazyPut<BookmarkRepository>(() => BookmarkRepositoryImpl(), fenix: true);
    Get.lazyPut<ApplyJobRepository>(() => ApplyJobRepositoryImpl(), fenix: true);
    Get.lazyPut<RequestRepository>(() => RequestRepositoryImpl(), fenix: true);
    Get.lazyPut<MyProjectRepository>(() => MyProjectsRepositoryImpl(), fenix: true);
    Get.lazyPut<BankDetailsRepository>(() => BankDetailsRepositoryImpl(), fenix: true);
    Get.lazyPut<NotificationRepository>(() => NotificationRepositoryImpl(apiProvider: Get.find()), fenix: true);
    Get.lazyPut<EmailRepository>(() => EmailRepositoryImpl(apiProvider: Get.find()), fenix: true);

    //Usecases
    Get.lazyPut(() => LoginUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => CheckAuthStatusUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetAllSpecificationUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetAllIndustriesUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => UploadFileUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => RegisterUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => ProjectsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => ProfileUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => DeleteBookmarkUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => BookmarkUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetAllBookmarksUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => ApplyJobUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => RequestsUseCase(Get.find()), fenix: true);
    Get.lazyPut(()=> OtpRequestUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => MyProjectUsecase(Get.find()), fenix: true);
    Get.lazyPut(() => BankDetailsUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => SendEmailUseCase(Get.find()), fenix: true);

    //controllers
    Get.lazyPut(() => ChatBadgeController(), fenix: true);
    Get.lazyPut(() => SearchPageController(), fenix: true);
    Get.lazyPut(() => ApplicationsController(), fenix: true);
    Get.lazyPut(() => ApplyController(), fenix: true);
    Get.lazyPut(() => ChangePassController(), fenix: true);
    Get.lazyPut(() => ChatController(), fenix: true);
    Get.lazyPut(() => DashboardController(), fenix: true);
    Get.lazyPut(() => ForgetPasswordController(), fenix: true);
    Get.lazyPut(() => GetStartedController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(() => MyProjectsController(), fenix: true);
    Get.lazyPut(() => NotificationsController(), fenix: true);
    Get.lazyPut(() => OtpController(), fenix: true);
    Get.lazyPut(() => ProjectDetailController(), fenix: true);
    Get.lazyPut(() => RegisterController(), fenix: true);
    Get.lazyPut(() => RequestsBadgeController(), fenix: true);
    Get.lazyPut(() => RequestsController(), fenix: true);
    Get.lazyPut(() => SavedController(), fenix: true);
    Get.lazyPut(() => SplashController(), fenix: true);
  }
}
