//обновление датасорса для работы с Secure Storage
import 'package:social_platform_example/core/security/secure_storage_service.dart';
import 'local_token_data_source.dart';

class SecureStorageTokenSource implements LocalTokenDataSource{

  final SecureStorageService _secureStorage;

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  SecureStorageTokenSource({required SecureStorageService secureStorage})
      : _secureStorage = secureStorage;

  @override
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(_accessKey, token);
  }

  @override
  Future<String?> getAccessToken() => _secureStorage.read(_accessKey);

  @override
  Future<void> clearAccessToken() async{
    await _secureStorage.delete(_accessKey);
  }

  @override
  Future<void> saveRefreshToken(String token) async{
    await _secureStorage.write(_refreshKey, token);
  }

  @override
  Future<String?> getRefreshToken() => _secureStorage.read(_refreshKey);

  @override
  Future<void> clearRefreshToken() async{
    await _secureStorage.delete(_refreshKey);
  }
}