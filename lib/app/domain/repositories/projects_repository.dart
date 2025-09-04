import 'package:mavx_flutter/app/data/models/projects_model.dart';

abstract class ProjectsRepository {
  Future<ProjectResponse> getProjects({int page = 1, int limit = 10});
}