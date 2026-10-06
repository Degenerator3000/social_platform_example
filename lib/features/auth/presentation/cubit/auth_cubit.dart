import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_platform_example/features/auth/domain/usecases/login_use_case.dart';
import 'package:social_platform_example/features/auth/domain/usecases/logout_use_case.dart';
import 'package:social_platform_example/features/auth/domain/usecases/restore_session_use_case.dart';
import 'package:social_platform_example/features/auth/domain/usecases/refresh_token_use_case.dart';
import 'package:social_platform_example/features/auth/domain/entities/auth_credentials.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState>{
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final CheckAuthUseCase checkAuthUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.checkAuthUseCase,
  }) : super(AuthInitial());

  Future<void> login(AuthCredentials credentials) async {
    emit(const AuthLoading());
    try {
      final loginResult = await loginUseCase(credentials);
      emit(AuthAuthenticated(user: loginResult.user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> logout() async {
    emit(const AuthLoading());
    try {
      await logoutUseCase();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> checkAuth() async {
    emit(const AuthLoading());
    try {
      final user = await checkAuthUseCase();
      if (user != null){
        emit(AuthAuthenticated(user: user));
      }
      else{
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}