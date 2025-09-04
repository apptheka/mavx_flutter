import 'package:mavx_flutter/app/data/models/similar_project_model.dart';
import 'package:mavx_flutter/app/domain/repositories/similar_projects_repository.dart';

class GetSimilarProjectsUseCase {
  final SimilarProjectsRepository repository;
  GetSimilarProjectsUseCase(this.repository);

  Future<List<SimilarProject>> getProjects() {
    return repository.getSimilarProjects();
  }
}
