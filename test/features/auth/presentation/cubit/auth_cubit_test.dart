import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:social_platform_example/features/auth/domain/entities/auth_credentials.dart';
import 'package:social_platform_example/features/auth/domain/entities/user.dart';
import 'package:social_platform_example/features/auth/domain/entities/login_result.dart';
import 'package:social_platform_example/features/auth/domain/entities/auth_token.dart';
import 'package:social_platform_example/features/auth/domain/usecases/validate_session_use_case.dart';
import 'package:social_platform_example/features/auth/domain/usecases/login_use_case.dart';
import 'package:social_platform_example/features/auth/domain/usecases/logout_use_case.dart';
import 'package:social_platform_example/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_platform_example/features/auth/presentation/cubit/auth_state.dart';

import 'auth_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LoginUseCase>(),
  MockSpec<LogoutUseCase>(),
  MockSpec<CheckAuthUseCase>(),
])
void main() {
  late MockLoginUseCase mockLoginUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockCheckAuthUseCase mockCheckAuthUseCase;

  final testUser = User(id: '1', username: 'testuser');
  final testCredentials = AuthCredentials(
    username: 'testuser',
    password: 'password123',
  );
  final loginResult = LoginResult(
    user: testUser,
    token: AuthToken(value: 'fake-jwt-token'),
  );

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockCheckAuthUseCase = MockCheckAuthUseCase();
  });

  group('Login', () {
    blocTest<AuthCubit, AuthState>(
      'должен испускать [AuthLoading, AuthAuthenticated] при успешном входе',
      build: () => AuthCubit(
        loginUseCase: mockLoginUseCase,
        logoutUseCase: mockLogoutUseCase,
        checkAuthUseCase: mockCheckAuthUseCase,
      ),
      setUp: () {
        when(mockLoginUseCase(testCredentials))
            .thenAnswer((_) async => loginResult);
      },
      act: (cubit) => cubit.login(testCredentials),
      expect: () => [
        const AuthLoading(),
        AuthAuthenticated(user: testUser),
      ],
      verify: (_) {
        verify(mockLoginUseCase(testCredentials)).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'должен испускать [AuthLoading, AuthError] при ошибке входа',
      build: () => AuthCubit(
        loginUseCase: mockLoginUseCase,
        logoutUseCase: mockLogoutUseCase,
        checkAuthUseCase: mockCheckAuthUseCase,
      ),
      setUp: () {
        when(mockLoginUseCase(testCredentials))
            .thenThrow(Exception('Неверный пароль'));
      },
      act: (cubit) => cubit.login(testCredentials),
      expect: () => [
        const AuthLoading(),
        const AuthError(message: 'Exception: Неверный пароль'),
      ],
      verify: (_) {
        verify(mockLoginUseCase(testCredentials)).called(1);
      },
    );
  });

  group('Logout', () {
    blocTest<AuthCubit, AuthState>(
      'должен испускать [AuthLoading, AuthInitial] при успешном выходе',
      build: () => AuthCubit(
        loginUseCase: mockLoginUseCase,
        logoutUseCase: mockLogoutUseCase,
        checkAuthUseCase: mockCheckAuthUseCase,
      ),
      setUp: () {
        when(mockLogoutUseCase()).thenAnswer((_) async => {});
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        const AuthLoading(),
        AuthInitial(),
      ],
      verify: (_) {
        verify(mockLogoutUseCase()).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'должен испускать [AuthLoading, AuthError] при ошибке выхода',
      build: () => AuthCubit(
        loginUseCase: mockLoginUseCase,
        logoutUseCase: mockLogoutUseCase,
        checkAuthUseCase: mockCheckAuthUseCase,
      ),
      setUp: () {
        when(mockLogoutUseCase()).thenThrow(Exception('Сетевая ошибка'));
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        const AuthLoading(),
        const AuthError(message: 'Exception: Сетевая ошибка'),
      ],
      verify: (_) {
        verify(mockLogoutUseCase()).called(1);
      },
    );
  });

  group('CheckAuth', () {
    blocTest<AuthCubit, AuthState>(
      'должен испускать [AuthLoading, AuthAuthenticated], если пользователь уже вошёл',
      build: () => AuthCubit(
        loginUseCase: mockLoginUseCase,
        logoutUseCase: mockLogoutUseCase,
        checkAuthUseCase: mockCheckAuthUseCase,
      ),
      setUp: () {
        when(mockCheckAuthUseCase()).thenAnswer((_) async => testUser);
      },
      act: (cubit) => cubit.checkAuth(),
      expect: () => [
        const AuthLoading(),
        AuthAuthenticated(user: testUser),
      ],
      verify: (_) {
        verify(mockCheckAuthUseCase()).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'должен испускать [AuthLoading, AuthInitial], если пользователь не вошёл',
      build: () => AuthCubit(
        loginUseCase: mockLoginUseCase,
        logoutUseCase: mockLogoutUseCase,
        checkAuthUseCase: mockCheckAuthUseCase,
      ),
      setUp: () {
        when(mockCheckAuthUseCase()).thenAnswer((_) async => null);
      },
      act: (cubit) => cubit.checkAuth(),
      expect: () => [
        const AuthLoading(),
        AuthInitial(),
      ],
      verify: (_) {
        verify(mockCheckAuthUseCase()).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'должен испускать [AuthLoading, AuthError] при ошибке проверки',
      build: () => AuthCubit(
        loginUseCase: mockLoginUseCase,
        logoutUseCase: mockLogoutUseCase,
        checkAuthUseCase: mockCheckAuthUseCase,
      ),
      setUp: () {
        when(mockCheckAuthUseCase()).thenThrow(Exception('Токен истёк'));
      },
      act: (cubit) => cubit.checkAuth(),
      expect: () => [
        const AuthLoading(),
        const AuthError(message: 'Exception: Токен истёк'),
      ],
      verify: (_) {
        verify(mockCheckAuthUseCase()).called(1);
      },
    );
  });
}