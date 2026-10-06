//более точный интерфейс для работы с сервером
import 'package:social_platform_example/features/auth/domain/entities/auth_credentials.dart';
import 'package:social_platform_example/features/auth/domain/entities/auth_tokens.dart';

abstract class RemoteTokenDataSource {
  Future<AuthTokens> login(AuthCredentials credentials);

  Future<AuthTokens> refresh(String refreshToken);

  Future<bool> verifyToken(String accessToken);
}