//Новый датасорс для работы с хранилищем токенов
//Переименованы CRUD функции
abstract class LocalTokenDataSource {
  Future<void> saveAccessToken(String token);

  Future<String?> getAccessToken();

  Future<void> clearAccessToken();

  Future<void> saveRefreshToken(String token);

  Future<String?> getRefreshToken();

  Future<void> clearRefreshToken();
}