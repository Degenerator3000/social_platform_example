import 'dart:async';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:social_platform_example/core/error/exceptions.dart';
import 'package:social_platform_example/features/auth/domain/repositories/auth_repository.dart';
import 'package:social_platform_example/features/auth/data/datasources/remote_token_data_source.dart';
import 'package:social_platform_example/features/auth/domain/entities/auth_credentials.dart';
import 'package:social_platform_example/features/auth/domain/repositories/token_repository.dart';
import 'package:social_platform_example/features/auth/domain/failures/auth_failure.dart';
import 'package:social_platform_example/features/auth/domain/entities/auth_tokens.dart';
import 'package:social_platform_example/core/result/result.dart';


class AuthRepositoryImpl implements AuthRepository{
  final RemoteTokenDataSource remoteTokenDataSource;
  final TokenRepository tokenRepository;

  Completer<Result<AuthTokens, AuthFailure>>? _refreshCompleter;

  AuthRepositoryImpl({required this.remoteTokenDataSource, required this.tokenRepository});

  @override
  Future<Result<AuthTokens, AuthFailure>> login(AuthCredentials credentials) async{
    try {
      final tokens = await remoteTokenDataSource.login(credentials);
      await tokenRepository.saveAccessToken(tokens.accessToken);
      await tokenRepository.saveRefreshToken(tokens.refreshToken);
      return Success(tokens);
    }
    on WrongCredentialsException catch (_){
      return Failure(AuthFailure.wrongCredentials());
    }
    on NetworkException catch(_){
      return Failure(AuthFailure.wrongCredentials());
    }
    on ServerException catch(e){
      return Failure(AuthFailure.server(e.message));
    }
    catch (e){
      return Failure(AuthFailure.unknown(e.toString()));
    }
  }

  @override
  Future<void> logout() async{
    await tokenRepository.clearRefreshToken();
    await tokenRepository.clearAccessToken();
  }

  @override
  Future<Result<AuthTokens, AuthFailure>> restore() async{
    try {
      final accessToken = await tokenRepository.getValidAccessToken();
      if (accessToken == null) {
        return refresh();
      }
      else {
        final refreshToken = await tokenRepository.getRefreshToken();
        return Success(AuthTokens(accessToken: accessToken,
            refreshToken: refreshToken ?? '',
            expiresIn: JwtDecoder.decode(accessToken)['exp'] as int
        ));
      }
    }
    catch (e){
      return Failure(AuthFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Result<AuthTokens, AuthFailure>> refresh() async {
    _refreshCompleter = Completer<Result<AuthTokens, AuthFailure>>();
    if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
      final result = await _refreshCompleter!.future;
      return result;
    }
    try {
      final refreshToken = await tokenRepository.getValidRefreshToken();
      if (refreshToken == null) {
        return Failure(AuthFailure.refreshTokenExpired());
      }
      final newTokens = await remoteTokenDataSource.refresh(refreshToken);
      await tokenRepository.saveAccessToken(newTokens.accessToken);
      await tokenRepository.saveRefreshToken(newTokens.refreshToken);
      _refreshCompleter!.complete(Success(newTokens));
      return Success(newTokens);
    }
    on RefreshTokenExpiredException catch (_) {
      _refreshCompleter!.complete(Failure(AuthFailure.refreshTokenExpired()));
      return Failure(AuthFailure.refreshTokenExpired());
    }
    on NetworkException catch (_) {
      _refreshCompleter!.complete(Failure(AuthFailure.network()));
      return Failure(AuthFailure.network());
    }
    on ServerException catch (e) {
      _refreshCompleter!.complete(Failure(AuthFailure.server(e.message)));
      return Failure(AuthFailure.server(e.message));
    }
    catch (e) {
      _refreshCompleter!.complete(Failure(AuthFailure.unknown(e.toString())));
      return Failure(AuthFailure.unknown(e.toString()));
    }
    finally {
      _refreshCompleter = null;
    }
  }
}