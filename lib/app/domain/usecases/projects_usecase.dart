import 'package:mavx_flutter/app/data/models/projects_model.dart';
import 'package:mavx_flutter/app/domain/repositories/projects_repository.dart';

class ProjectsUseCase {
 final ProjectsRepository projectsRepository; 
 ProjectsUseCase(this.projectsRepository);

 Future<ProjectResponse> projects({int page = 1, int limit = 10}) async {
  return await projectsRepository.getProjects(page: page, limit: limit);
 }
  
}