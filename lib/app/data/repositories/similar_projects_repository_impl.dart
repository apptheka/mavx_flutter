import 'dart:async';

import 'package:mavx_flutter/app/data/models/similar_project_model.dart';
import 'package:mavx_flutter/app/domain/repositories/similar_projects_repository.dart';

class SimilarProjectsRepositoryImpl implements SimilarProjectsRepository {
  SimilarProjectsRepositoryImpl();

  @override
  Future<List<SimilarProject>> getSimilarProjects() async {
    // Simulated network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Static data for now (can be replaced with ApiProvider call later)
    const seed = [
      {
        'title': 'Senior Product Consultant',
        'company': 'BlueOrbit Solutions',
        'location': 'New York, USA',
        'salary': '25K - 35K',
        'tag': '92% Match',
      },
      {
        'title': 'Org Design Specialist',
        'company': 'Corelight Labs',
        'location': 'Remote',
        'salary': '18K - 28K',
        'tag': 'New',
      },
      {
        'title': 'Transformation Lead',
        'company': 'Nimbus Partners',
        'location': 'San Francisco, USA',
        'salary': '40K - 60K',
        'tag': '90% Match',
      },
    ];

    return seed.map((e) => SimilarProject.fromMap(Map<String, String>.from(e))).toList();
  }
}
