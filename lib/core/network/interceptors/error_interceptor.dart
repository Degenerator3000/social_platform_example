import 'package:dio/dio.dart';

/// Преобразует DioException в доменные ошибки приложения.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final appError = _mapError(err);
    handler.reject(appError);
  }

  DioException _mapError(DioException e) {
    // Здесь можно вернуть кастомную AppException,
    // но для простоты оставим DioException с понятным сообщением
    String message;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Превышено время ожидания. Проверьте соединение.';
        break;
      case DioExceptionType.connectionError:
        message = 'Нет подключения к интернету.';
        break;
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        message = code == 401
            ? 'Сессия истекла. Войдите снова.'
            : 'Ошибка сервера ($code)';
        break;
      default:
        message = 'Произошла неизвестная ошибка.';
    }
    return e.copyWith(error: message);
  }
}