import 'package:mavx_flutter/app/data/models/projects_model.dart';
import 'package:mavx_flutter/app/domain/repositories/projects_repository.dart';

class ProjectsUseCase {
 final ProjectsRepository projectsRepository; 
 ProjectsUseCase(this.projectsRepository);

 Future<ProjectResponse> projects({int page = 1, int? limit}) async {
  return await projectsRepository.getProjects(page: page, limit: limit);
 }
  Future<ProjectResponse> projectById(int id) async {
    return await projectsRepository.projectById(id);
  }

  Future<ProjectResponse> search({
    required String search,
    String type = '',
    String industry = '',
    String specialisation = '',
    int page = 1,
    int? limit,
  }) async {
    return await projectsRepository.searchProjects(
      search: search,
      type: type,
      industry: industry,
      specialisation: specialisation,
      page: page,
      limit: limit,
    );
  }
}