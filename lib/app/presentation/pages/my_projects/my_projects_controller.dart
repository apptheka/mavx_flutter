import 'package:get/get.dart';
import 'package:mavx_flutter/app/data/models/completed_projects_model.dart' as confirmed;
import 'package:mavx_flutter/app/domain/usecases/my_project_usecase.dart';
import 'package:mavx_flutter/app/data/repositories/my_projects_repository_impl.dart';

class MyProjectsController extends GetxController {
  MyProjectsController({MyProjectUsecase? usecase})
      : _usecase = usecase ?? _ensureUsecase();

  final MyProjectUsecase _usecase;

  final RxBool loading = false.obs;
  final RxString error = ''.obs;
  final RxList<confirmed.ProjectModel> projects = <confirmed.ProjectModel>[].obs;

  static MyProjectUsecase _ensureUsecase() {
    try {
      return Get.find<MyProjectUsecase>();
    } catch (_) {
      return Get.put(MyProjectUsecase(Get.put(MyProjectsRepositoryImpl())));
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    loading.value = true;
    error.value = '';
    try {
      final list = await _usecase.getMyConfirmedProjects();
      projects.assignAll(list);
    } catch (e) {
      error.value = 'Something went wrong';
    } finally {
      loading.value = false;
    }
  }
}
