import 'package:dio/dio.dart';
import '../config/app_config.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    final config = AppConfig();
    _dio = Dio(
      BaseOptions(
        baseUrl: config.apiUrl,
        connectTimeout: Duration(seconds: config.connectTimeout),
        receiveTimeout: Duration(seconds: config.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  Dio get dio => _dio;
}