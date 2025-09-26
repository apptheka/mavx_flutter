import 'package:mavx_flutter/app/data/models/completed_projects_model.dart';
import 'package:mavx_flutter/app/data/models/timesheet_model.dart';
import 'package:mavx_flutter/app/domain/repositories/my_project_repository.dart';

class MyProjectUsecase {
  final MyProjectRepository myProjectRepository;

  MyProjectUsecase(this.myProjectRepository);

  Future<List<ProjectModel>> getMyConfirmedProjects() {
    return myProjectRepository.getMyConfirmedProjects();
  }

  Future<bool> createProjectSchedule(Map<String, dynamic> payload) {
    return myProjectRepository.createProjectSchedule(payload);
  }

  Future<List<Timesheet>> getTimesheets(int projectId, int expertId) {
    return myProjectRepository.getTimesheets(projectId, expertId);
  } 

  Future<bool> uploadInvoice({required Map<String, String> fields, String? filePath}) {
    return myProjectRepository.uploadInvoice(fields: fields, filePath: filePath);
  }
}
