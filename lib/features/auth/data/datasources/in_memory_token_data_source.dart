///нейронный код, т.к. в данный момент изучение генерации jwt токенов не в приоритете
import 'dart:math';
import 'package:t_jwt/t_jwt.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'remote_token_data_source.dart';
import 'package:social_platform_example/features/auth/domain/entities/auth_credentials.dart';
import 'package:social_platform_example/features/auth/domain/entities/auth_tokens.dart';

/// In-memory заглушка для RemoteTokenDataSource.
/// Эмулирует поведение JWT-сервера без реальной криптографии.
class InMemoryTokenDataSource implements RemoteTokenDataSource {
  // Секретный ключ для подписи JWT (в реальном проекте хранится на сервере)
  static const String _secretKey = 'in-memory-secret-key-for-testing';

  // Хранилище "активных" refresh-токенов (эмуляция серверной БД)
  final Set<String> _validRefreshTokens = {};

  // Генератор случайных чисел для создания ID
  final Random _random = Random();

  // Длительность жизни токенов (для эмуляции)
  static const Duration _accessTokenLifetime = Duration(minutes: 15);
  static const Duration _refreshTokenLifetime = Duration(days: 7);

  @override
  Future<AuthTokens> login(AuthCredentials credentials) async {
    // 1. Эмуляция проверки учетных данных
    // В реальном приложении здесь была бы проверка в БД
    if (credentials.username.isEmpty || credentials.password.isEmpty) {
      throw Exception('Invalid credentials');
    }

    // 2. Генерация пары токенов
    final userId = 'user_${_random.nextInt(10000)}';
    final tokens = _generateTokens(userId);

    // 3. Сохраняем refresh-токен в "базе данных" сервера
    _validRefreshTokens.add(tokens.refreshToken);

    return tokens;
  }

  @override
  Future<AuthTokens> refresh(String refreshToken) async {
    // 1. Проверяем, существует ли refresh-токен в "БД" сервера
    if (!_validRefreshTokens.contains(refreshToken)) {
      throw Exception('Invalid or expired refresh token');
    }

    // 2. Декодируем refresh-токен, чтобы получить userId
    String userId;
    try {
      final payload = JwtDecoder.decode(refreshToken);
      userId = payload['sub'] as String;
    } catch (e) {
      throw Exception('Invalid refresh token format');
    }

    // 3. Удаляем старый refresh-токен (одноразовое использование)
    _validRefreshTokens.remove(refreshToken);

    // 4. Генерируем новую пару токенов
    final newTokens = _generateTokens(userId);

    // 5. Сохраняем новый refresh-токен
    _validRefreshTokens.add(newTokens.refreshToken);

    return newTokens;
  }

  @override
  Future<bool> verifyToken(String accessToken) async {
    try {
      // 1. Проверяем подпись токена
      final jwt = JWT(_secretKey);
      final isVerified = jwt.verify(accessToken);

      if (!isVerified) return false;

      // 2. Проверяем срок действия (exp)
      final payload = JwtDecoder.decode(accessToken);
      final exp = payload['exp'] as int?;

      if (exp == null) return false;

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return expiryDate.isAfter(DateTime.now());
    } catch (e) {
      // Любая ошибка при декодировании = токен невалидный
      return false;
    }
  }

  // === Вспомогательные методы ===

  /// Генерирует пару access + refresh токенов для пользователя
  AuthTokens _generateTokens(String userId) {
    final now = DateTime.now();

    // Access Token (живет 15 минут)
    final accessPayload = <String, dynamic>{
      'sub': userId,
      'iat': now.millisecondsSinceEpoch ~/ 1000,
      'iss': 'in-memory-auth-server',
    };

    final accessToken = _signJwt(accessPayload,
      now.add(_accessTokenLifetime));

    // Refresh Token (живет 7 дней)
    final refreshPayload = <String, dynamic>{
      'sub': userId,
      'iat': now.millisecondsSinceEpoch ~/ 1000,
      'iss': 'in-memory-auth-server',
      'type': 'refresh',
    };

    final refreshToken = _signJwt(refreshPayload,
        now.add(_refreshTokenLifetime));

    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: _accessTokenLifetime.inSeconds,
    );
  }

  /// Подписывает JWT с использованием HS256
  String _signJwt(Map<String, dynamic> payload, DateTime expiresAt) {
    final jwt = JWT(_secretKey);
    final header = <String, String>{
      'alg': 'HS256',
      'typ': 'JWT',
    };

    // t_jwt ожидает Map<String, String> для payload,
    // поэтому конвертируем все значения в строки
    final stringPayload = payload.map((key, value) => MapEntry(key, value.toString()));

    // Передаем null для expiresAt, так как мы уже указали 'exp' в payload
    return jwt.sign(header, stringPayload, expiresAt);
  }
}