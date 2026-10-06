import 'dart:async';
import 'package:dio/dio.dart';
import 'package:social_platform_example/core/services/token_provider.dart';

class RefreshTokenInterceptor extends Interceptor {
  final TokenProvider _tokenProvider;
  final Dio _dio;

  RefreshTokenInterceptor(this._tokenProvider, this._dio);

  // Single-flight: общий Future для всех параллельных 401
  Completer<void>? _refreshCompleter;

  @override
  Future<void> onError(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    // 1. Не 401 или уже повторяли — пропускаем
    if (err.response?.statusCode != 401 ||
        err.requestOptions.extra['_isRetryAfterRefresh'] == true ||
        err.requestOptions.extra['skipAuth'] == true) {
      return handler.next(err);
    }

    err.requestOptions.extra['_isRetryAfterRefresh'] = true;

    // 2. Если refresh уже идёт — ждём тот же Completer
    final existing = _refreshCompleter;
    if (existing != null) {
      try {
        await existing.future;
        return _retryRequest(err, handler);
      } catch (_) {
        return handler.next(err);
      }
    }

    final completer = Completer<void>();
    _refreshCompleter = completer;

    try {
      final currentToken = await _tokenProvider.getValidAccessToken();
      if (currentToken != null) {
        completer.complete();
      } else {
        await _performRefresh();
        completer.complete();
      }
    } catch (e) {
      completer.completeError(e);
      await _tokenProvider.clearTokens(); // → сработает onSessionExpired
    } finally {
      _refreshCompleter = null;
    }

    // 4. Инициатор тоже ждёт свой completer — единый путь для всех
    try {
      await completer.future;
      return _retryRequest(err, handler);
    } catch (_) {
      return handler.next(err);
    }
  }

  /// Сам refresh через основной _dio с флагом skipAuth.
  Future<void> _performRefresh() async {
    final refreshToken = await _tokenProvider.getValidRefreshToken();
    if (refreshToken == null) {
      throw Exception('Refresh token is null or expired');
    }

    final response = await _dio.post(
      '/refresh',
      data: {'refreshToken': refreshToken},
      options: Options(
        // Ключевой момент: AuthInterceptor пропустит этот запрос,
        // и на него не подставится просроченный access token
        extra: {'skipAuth': true},
      ),
    );

    final newAccessToken = response.data['accessToken'] as String;
    final newRefreshToken = response.data['refreshToken'] as String;

    await _tokenProvider.saveTokens(newAccessToken, newRefreshToken);
  }

  /// Повторяет исходный запрос с обновлённым токеном.
  Future<void> _retryRequest(
      DioException err,
      ErrorInterceptorHandler handler,
      ) async {
    // _dio.fetch прогоняет запрос через AuthInterceptor,
    // который сам подставит свежий токен. Вручную ставить заголовок не нужно.
    try {
      final response = await _dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }
}