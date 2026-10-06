import 'package:social_platform_example/features/auth/domain/repositories/auth_repository.dart';

class RefreshTokenUseCase {
  final AuthRepository authRepository;

  const RefreshTokenUseCase({required this.authRepository});

  Future<void> call(){
    return authRepository.refresh();
  }
}