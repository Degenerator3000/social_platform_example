import 'package:social_platform_example/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository authRepository;

  const LogoutUseCase({required this.authRepository});

  Future<void> call() {
    return authRepository.logout();
  }
}