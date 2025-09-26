import 'package:mavx_flutter/app/data/models/completed_projects_model.dart';
import 'package:mavx_flutter/app/data/models/timesheet_model.dart';

abstract class MyProjectRepository {
  Future<List<ProjectModel>> getMyConfirmedProjects();
  Future<bool> createProjectSchedule(Map<String, dynamic> payload);
  Future<List<Timesheet>> getTimesheets(int projectId, int expertId);
  Future<bool> uploadInvoice({
    required Map<String, String> fields,
    String? filePath,
  });
}