import 'package:mavx_flutter/app/data/models/industries_model.dart';

abstract class IndustriesRepository {
 Future<IndustriesResponse> getAllIndustries(); 
}