import 'dart:async';
abstract class TokenRepository {
  Future<void> saveAccessToken(String token);

  Future<String?> getAccessToken();

  Future<void> clearAccessToken();

  Future<void> saveRefreshToken(String token);

  Future<String?> getRefreshToken();

  Future<void> clearRefreshToken();

  Future<String?> getValidRefreshToken();

  Future<String?> getValidAccessToken();
}