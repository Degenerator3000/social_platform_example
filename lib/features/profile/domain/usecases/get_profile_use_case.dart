import 'package:social_platform_example/features/profile/domain/entities/profile_data.dart';
import 'package:social_platform_example/features/profile/domain/repositories/profile_repository.dart';

class GetProfileUseCase {
  final ProfileRepository profileRepository;

  GetProfileUseCase({
    required this.profileRepository,
  });

  Future<ProfileData> call() async{
    return profileRepository.getProfile();
  }
}