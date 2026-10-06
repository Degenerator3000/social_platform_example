import 'dart:async';
import 'package:social_platform_example/features/auth/domain/entities/auth_credentials.dart';
import 'package:social_platform_example/features/auth/domain/entities/auth_tokens.dart';
import 'package:social_platform_example/features/auth/domain/failures/auth_failure.dart';
import 'package:social_platform_example/core/result/result.dart';


abstract class AuthRepository {
  Future<Result<AuthTokens, AuthFailure>> login(AuthCredentials credentials);
  Future<void> logout();
  Future<Result<AuthTokens, AuthFailure>> restore();
  Future<Result<AuthTokens, AuthFailure>> refresh();
}