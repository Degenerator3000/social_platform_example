import 'package:social_platform_example/features/auth/domain/repositories/auth_repository.dart';
import 'package:social_platform_example/features/auth/domain/entities/auth_credentials.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  const LoginUseCase({required this.authRepository});

  Future<void> call(AuthCredentials credentials) {
    return authRepository.login(credentials);
  }
}