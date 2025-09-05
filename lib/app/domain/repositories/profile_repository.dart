import 'package:mavx_flutter/app/data/models/complete_profile_model.dart';
import 'package:mavx_flutter/app/data/models/user_registered_model.dart';

abstract class ProfileRepository {
  Future<UserProfile> getProfile();
  Future<UserRegisteredModel> getRegisteredProfile();

}