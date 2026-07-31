import 'package:social_platform_example/features/auth/domain/entities/auth_token.dart';
import 'package:social_platform_example/core/security/secure_storage_service.dart';
import 'token_data_source.dart';
class SecureStorageTokenSource implements TokenDataSource{

  final SecureStorageService _secureStorage;

  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'auth_user_id';

  SecureStorageTokenSource({required SecureStorageService secureStorage})
      : _secureStorage = secureStorage;

  @override
  Future<void> saveToken(AuthToken token) async {
    await _secureStorage.write(_tokenKey, token.value);
  }

  @override
  Future<AuthToken?> getToken() async{
    final authToken = await _secureStorage.read(_tokenKey);
    if (authToken != null){
      return AuthToken(value: authToken);
    }
    return null;
  }

  @override
  Future<void> clearToken() async{
    await _secureStorage.delete(_tokenKey);
  }

  @override
  Future<void> saveUserId(String id) async {
    await _secureStorage.write(_userIdKey, id);
  }

  @override
  Future<String?> getUserId() async {
    return await _secureStorage.read(_userIdKey);
  }

  @override
  Future<void> clearUserId() async {
    await _secureStorage.delete(_userIdKey);
  }
}