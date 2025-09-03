import 'package:mavx_flutter/app/data/models/specifications_model.dart';

abstract class SpecificationRepository {
 Future<JobRolesResponse> getAllSpecification(); 
}