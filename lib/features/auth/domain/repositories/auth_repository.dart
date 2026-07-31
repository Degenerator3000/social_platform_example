import 'dart:async';
import 'package:social_platform_example/features/auth/domain/entities/login_result.dart';
import 'package:social_platform_example/features/auth/domain/entities/auth_credentials.dart';
import 'package:social_platform_example/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<LoginResult> login(AuthCredentials credentials);
  Future<void> logout();
  Future<User?> checkAuth();   // возвращает пользователя, если сессия активна
  Future<User> getCurrentUser();
}