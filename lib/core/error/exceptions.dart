class WrongCredentialsException implements Exception {
  final String message;
  const WrongCredentialsException([this.message = 'Неверный логин или пароль']);

  @override
  String toString() => message;
}

class NetworkException  implements Exception {
  final String message;
  const NetworkException ([this.message = 'Ошибка интернет соединения']);

  @override
  String toString() => message;
}

class ServerException implements Exception {
  final String message;
  const ServerException([this.message = 'ошибка сервера']);

  @override
  String toString() => message;
}

class RefreshTokenExpiredException implements Exception {
  final String message;
  const RefreshTokenExpiredException([this.message = 'Сессия истекла']);

  @override
  String toString() => message;
}