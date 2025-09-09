import 'package:mavx_flutter/app/data/models/projects_model.dart';

abstract class ProjectsRepository {
  Future<ProjectResponse> getProjects({int page = 1, int? limit});
  Future<ProjectResponse> projectById(int id);
  Future<ProjectResponse> searchProjects({
    required String search,
    String type = '',
    String industry = '',
    String specialisation = '',
    int page = 1,
    int? limit,
  });
}