import 'package:dio/dio.dart';
import 'package:social_platform_example/core/services/token_provider.dart';

class AuthInterceptor extends Interceptor {
  final TokenProvider _tokenProvider;

  AuthInterceptor(this._tokenProvider);

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    // Пропускаем refresh, логин и всё, что помечено skipAuth
    if (options.extra['skipAuth'] == true) {
      return handler.next(options);
    }

    final token = await _tokenProvider.getValidAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}