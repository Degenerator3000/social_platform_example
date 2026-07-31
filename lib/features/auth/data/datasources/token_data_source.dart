import 'package:social_platform_example/features/auth/domain/entities/auth_token.dart';
abstract class TokenDataSource {
  Future<void> saveToken(AuthToken token);

  Future<AuthToken?> getToken();

  Future<void> clearToken();

  Future<void> saveUserId(String id);

  Future<String?> getUserId();

  Future<void> clearUserId();
}