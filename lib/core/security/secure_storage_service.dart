import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Сервис для безопасного хранения конфиденциальных данных (токены, ключи).
/// Использует платформенное защищённое хранилище:
/// - Android: EncryptedSharedPreferences
/// - iOS: Keychain
class SecureStorageService {
  final FlutterSecureStorage _storage;

  /// Конструктор принимает экземпляр FlutterSecureStorage.
  /// По умолчанию использует стандартные настройки.
  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  /// Записать значение [value] по ключу [key].
  /// Если значение равно null, запись не производится (можно удалить ключ).
  Future<void> write(String key, String? value) async {
    if (value == null) {
      await _storage.delete(key: key);
    } else {
      await _storage.write(key: key, value: value);
    }
  }

  /// Прочитать значение по ключу [key].
  /// Возвращает null, если ключ не найден.
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Удалить значение по ключу [key].
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}