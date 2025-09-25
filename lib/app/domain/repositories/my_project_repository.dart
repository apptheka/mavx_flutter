import 'package:mavx_flutter/app/data/models/completed_projects_model.dart';

abstract class MyProjectRepository {
  Future<List< ProjectModel>> getMyConfirmedProjects();
  Future<bool> createProjectSchedule(Map<String, dynamic> payload);
}