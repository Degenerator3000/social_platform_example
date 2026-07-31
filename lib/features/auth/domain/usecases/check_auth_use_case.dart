import 'package:social_platform_example/features/auth/domain/repositories/auth_repository.dart';
import 'package:social_platform_example/features/auth/domain/entities/user.dart';

class CheckAuthUseCase {
  final AuthRepository authRepository;

  const CheckAuthUseCase({required this.authRepository});

  Future<User?> call() async {
    return await authRepository.checkAuth();
  }
}