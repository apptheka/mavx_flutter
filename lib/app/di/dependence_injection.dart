import 'package:get/get.dart';
import 'package:mavx_flutter/app/data/providers/api_provider.dart'
    show ApiProvider;
import 'package:mavx_flutter/app/data/repositories/apply_job_repository_impl.dart';
import 'package:mavx_flutter/app/data/repositories/auth_repository_impl.dart';
import 'package:mavx_flutter/app/data/repositories/bookmark_repository_impl.dart';
import 'package:mavx_flutter/app/data/repositories/industries_repository_impl.dart';
import 'package:mavx_flutter/app/data/repositories/profile_repository_impl.dart';
import 'package:mavx_flutter/app/data/repositories/projects_repository_impl.dart';
import 'package:mavx_flutter/app/data/repositories/request_respository_impl.dart';
import 'package:mavx_flutter/app/data/repositories/specification_repository_impl.dart';
import 'package:mavx_flutter/app/data/repositories/file_repository_impl.dart';
import 'package:mavx_flutter/app/domain/repositories/apply_job_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/auth_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/bookmarks_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/industries_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/profile_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/projects_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/request_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/specification_repository.dart';
import 'package:mavx_flutter/app/domain/repositories/file_repository.dart';
import 'package:mavx_flutter/app/domain/usecases/bookmark_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/delete_bookmark_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/get_all_bookmarks_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/check_auth_status_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/get_all_industries_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/get_all_specification_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/login_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/profile_usecases.dart';
import 'package:mavx_flutter/app/domain/usecases/projects_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/register_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/requests_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/upload_file_usecase.dart';
import 'package:mavx_flutter/app/domain/usecases/apply_job_usecase.dart';
import 'package:mavx_flutter/app/core/services/storage_service.dart';
import 'package:mavx_flutter/app/presentation/pages/profile/profile_controller.dart';

class DependenceInjection {
  static Future<void> init() async {
    // Initialize storage once at startup to avoid platform channel timing issues
    final storage = StorageService();
    await storage.init();
    Get.put<StorageService>(storage, permanent: true);

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
    Get.lazyPut<ProfileRepository>(() => ProfileRepositoryImpl(), fenix: true);
    Get.lazyPut<BookmarkRepository>(() => BookmarkRepositoryImpl(), fenix: true);
    Get.lazyPut<ApplyJobRepository>(() => ApplyJobRepositoryImpl(), fenix: true);
    Get.lazyPut<RequestRepository>(() => RequestRepositoryImpl(), fenix: true);
    

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
  }
}
