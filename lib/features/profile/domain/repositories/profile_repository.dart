import 'dart:async';
import 'package:social_platform_example/features/profile/domain/entities/profile_data.dart';

abstract class ProfileRepository {
  Future<ProfileData> getProfile();
}