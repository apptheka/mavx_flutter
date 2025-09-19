import 'package:mavx_flutter/app/data/models/completed_projects_model.dart';
import 'package:mavx_flutter/app/domain/repositories/my_project_repository.dart';

class MyProjectUsecase {
  final MyProjectRepository myProjectRepository;

  MyProjectUsecase(this.myProjectRepository);

  Future<List<ProjectModel>> getMyConfirmedProjects() {
    return myProjectRepository.getMyConfirmedProjects();
  }
}
