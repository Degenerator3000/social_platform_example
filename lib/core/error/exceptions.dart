class WrongCredentialsException implements Exception {
  final String message;
  const WrongCredentialsException([this.message = 'Неверный логин или пароль']);

  @override
  String toString() => message;
}

class NoActiveSessionException implements Exception {
  final String message;
  const NoActiveSessionException([this.message = 'Не удалось получить текущего пользователя']);

  @override
  String toString() => message;
}