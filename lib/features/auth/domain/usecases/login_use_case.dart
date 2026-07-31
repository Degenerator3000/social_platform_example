import 'package:social_platform_example/features/auth/domain/repositories/auth_repository.dart';
import 'package:social_platform_example/features/auth/domain/entities/login_result.dart';
import 'package:social_platform_example/features/auth/domain/entities/auth_credentials.dart';

class LoginUseCase {
  final AuthRepository authRepository;

  const LoginUseCase({required this.authRepository});

  Future<LoginResult> call(AuthCredentials credentials) async {
    return await authRepository.login(credentials);
  }
}