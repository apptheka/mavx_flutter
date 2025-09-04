import 'package:mavx_flutter/app/data/models/similar_project_model.dart';

abstract class SimilarProjectsRepository {
  Future<List<SimilarProject>> getSimilarProjects();
}
