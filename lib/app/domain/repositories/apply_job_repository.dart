import 'package:mavx_flutter/app/data/models/projects_model.dart';
abstract class ApplyJobRepository{ 
    Future<String> applyJob({
    required int projectId, 
    required String encryptedRequest,
  });

  /// Returns the list of projects the current user has applied to.
  /// Internally calls both:
  /// 1) get-apply-job/{userId} to get the IDs
  /// 2) get-user-apply-projects/{userId} to get the project details
  Future<List<ProjectModel>> getAppliedProjectsForCurrentUser();

  /// Returns the set of applied project IDs for the current user.
  Future<Set<int>> getAppliedProjectIdsForCurrentUser();
}