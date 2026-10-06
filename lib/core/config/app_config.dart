import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();

  Future<void> load() async => await dotenv.load();

  String get apiUrl => dotenv.get('API_URL');
  int get connectTimeout => dotenv.getInt('CONNECT_TIMEOUT', fallback: 10);
  int get receiveTimeout => dotenv.getInt('RECEIVE_TIMEOUT', fallback: 30);
  bool get debug => dotenv.getBool('DEBUG', fallback: false);
}