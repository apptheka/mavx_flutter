import 'package:mavx_flutter/app/data/models/specifications_model.dart';
import 'package:mavx_flutter/app/domain/repositories/specification_repository.dart';

class GetAllSpecificationUseCase {
  final SpecificationRepository _specificationRepository;

  GetAllSpecificationUseCase(this._specificationRepository);

  Future<JobRolesResponse> call() async {
    return await _specificationRepository.getAllSpecification();
  }
}