import 'package:mavx_flutter/app/data/models/projects_model.dart';
abstract class ApplyJobRepository{ 
    Future<String> applyJob({
    required int projectId, 
    required String encryptedRequest,
  });
 
  Future<List<ProjectModel>> getAppliedProjectsForCurrentUser();
 
  Future<Set<int>> getAppliedProjectIdsForCurrentUser();
}