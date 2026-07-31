import 'package:social_platform_example/features/profile/domain/repositories/profile_repository.dart';
import 'package:social_platform_example/features/profile/domain/entities/profile_data.dart';
import 'package:social_platform_example/features/profile/data/datasources/likes_count_data_source.dart';
import 'package:social_platform_example/features/auth/domain/repositories/auth_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository{

  final LikesCountDataSource likesCountDataSource;
  final AuthRepository authRepository;

  ProfileRepositoryImpl({
    required this.likesCountDataSource,
    required this.authRepository,
  });

  @override
  Future<ProfileData> getProfile() async{
    final likesCount = await likesCountDataSource.getLikesCount();
    final user = await authRepository.getCurrentUser();
    return ProfileData(user: user, likesCount: likesCount);
  }
}