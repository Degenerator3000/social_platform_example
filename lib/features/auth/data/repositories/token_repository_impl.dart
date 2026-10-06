import 'dart:async';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:social_platform_example/core/services/token_provider.dart';
import 'package:social_platform_example/features/auth/domain/repositories/token_repository.dart';
import 'package:social_platform_example/features/auth/data/datasources/local_token_data_source.dart';

class TokenRepositoryImpl implements TokenRepository, TokenProvider{

  bool _isTokenExpired(String token) {
    try {
      final exp = JwtDecoder.decode(token)['exp'] as int?;
      if (exp == null) return true;
      return DateTime.now().isAfter(DateTime.fromMillisecondsSinceEpoch(exp * 1000));
    } catch (_) {
      return true;
    }
  }

  final LocalTokenDataSource localTokenDataSource;


  TokenRepositoryImpl({required this.localTokenDataSource});

  final _sessionExpiredController = StreamController<void>.broadcast();

  @override
  Stream<void> get onSessionExpired => _sessionExpiredController.stream;

  @override
  Future<void> saveAccessToken(String token) =>
      localTokenDataSource.saveAccessToken(token);

  @override
  Future<String?> getAccessToken() => localTokenDataSource.getAccessToken();

  @override
  Future<void> clearAccessToken() => localTokenDataSource.clearAccessToken();


  @override
  Future<void> saveRefreshToken(String token) =>
      localTokenDataSource.saveRefreshToken(token);

  @override
  Future<String?> getRefreshToken() => localTokenDataSource.getRefreshToken();

  @override
  Future<void> clearRefreshToken() => localTokenDataSource.clearRefreshToken();

  @override
  Future<String?> getValidRefreshToken() async {
    final token = await getRefreshToken();
    if (token != null && !_isTokenExpired(token)){
      return token;
    }
    return null;
  }

  @override
  Future<String?> getValidAccessToken() async {
    final token = await getAccessToken();
    if (token != null && !_isTokenExpired(token)){
      return token;
    }
    return null;
  }

  @override
  Future<void> saveTokens(String access, String refresh) {
    return Future.wait([
      saveAccessToken(access),
      saveRefreshToken(refresh),
    ]);
  }

  @override
  Future<void> clearTokens() async{
    await Future.wait([
      clearAccessToken(),
      clearRefreshToken(),
    ]);
    _sessionExpiredController.add(null);
  }
}