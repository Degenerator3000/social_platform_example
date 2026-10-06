abstract class TokenProvider {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> saveTokens(String access, String refresh);
  Future<void> clearTokens();
  Future<String?> getValidAccessToken();
  Future<String?> getValidRefreshToken();

  Stream<void> get onSessionExpired;
}