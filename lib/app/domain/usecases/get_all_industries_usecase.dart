import 'package:mavx_flutter/app/data/models/industries_model.dart';
import 'package:mavx_flutter/app/domain/repositories/industries_repository.dart';

class GetAllIndustriesUseCase {
  final IndustriesRepository industriesRepository;
  GetAllIndustriesUseCase(this.industriesRepository);
  Future<IndustriesResponse> call() async {
    return industriesRepository.getAllIndustries();
  }
}