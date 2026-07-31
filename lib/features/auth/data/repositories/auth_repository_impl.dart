import 'dart:math';
import 'package:social_platform_example/core/error/exceptions.dart';
import 'package:social_platform_example/features/auth/domain/repositories/auth_repository.dart';
import 'package:social_platform_example/features/auth/data/datasources/auth_data_source.dart';
import 'package:social_platform_example/features/auth/domain/entities/auth_credentials.dart';
import 'package:social_platform_example/features/auth/domain/entities/auth_token.dart';
import 'package:social_platform_example/features/auth/domain/entities/user.dart';
import 'package:social_platform_example/features/auth/domain/entities/login_result.dart';
import 'package:social_platform_example/features/auth/data/datasources/token_data_source.dart';



class AuthRepositoryImpl implements AuthRepository{
  final AuthDataSource authDataSource;
  final TokenDataSource tokenDataSource;

  const AuthRepositoryImpl({required this.authDataSource, required this.tokenDataSource});

  String _generateToken() {
    return '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(999999)}';
  }

  Future<User?> _getUserIfAuthenticated() async {
    final token = await tokenDataSource.getToken();
    final userId = await tokenDataSource.getUserId();
    if (token != null && userId != null) {
      final userModel = await authDataSource.getUserById(userId);
      return userModel?.toEntity();
    }
    return null;
  }

  @override
  Future<LoginResult> login(AuthCredentials credentials) async{
    final userModel = await authDataSource.login(credentials);
    if (userModel != null){
      final token = AuthToken(value: _generateToken());
      await tokenDataSource.saveToken(token);
      await tokenDataSource.saveUserId(userModel.id);
      return LoginResult(
          user: userModel.toEntity(),
          token: token
      );
    }
    else {
      throw const WrongCredentialsException();
    }
  }

  @override
  Future<void> logout() async{
    await tokenDataSource.clearToken();
    await tokenDataSource.clearUserId();
  }

  @override
  Future<User?> checkAuth(){
    return _getUserIfAuthenticated();
  }

  @override
  Future<User> getCurrentUser() async{
    final user = await _getUserIfAuthenticated();
    if (user == null) throw const NoActiveSessionException();
    return user;
  }
}