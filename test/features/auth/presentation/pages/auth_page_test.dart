import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_platform_example/features/auth/domain/entities/auth_credentials.dart';
import 'package:social_platform_example/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_platform_example/features/auth/presentation/cubit/auth_state.dart';
import 'package:social_platform_example/features/auth/presentation/pages/auth_page.dart';

class MockAuthCubit extends Mock implements AuthCubit {}

void main() {
  late MockAuthCubit mockCubit;

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<AuthCubit>.value(
        value: mockCubit,
        child: const AuthPage(),
      ),
    );
  }

  setUp(() {
    mockCubit = MockAuthCubit();
    registerFallbackValue(const AuthInitial());
    registerFallbackValue(AuthCredentials(username: '', password: ''));

    when(() => mockCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockCubit.isClosed).thenReturn(false);
    when(() => mockCubit.checkAuth()).thenAnswer((_) async {});
  });

  group('AuthPage', () {
    testWidgets('показывает поля ввода и активную кнопку при AuthInitial',
            (tester) async {
          when(() => mockCubit.state).thenReturn(const AuthInitial());

          await tester.pumpWidget(buildTestableWidget());

          expect(find.byType(TextField), findsNWidgets(2));
          expect(find.text('Имя пользователя'), findsOneWidget);
          expect(find.text('Пароль'), findsOneWidget);
          final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
          expect(button.onPressed, isNotNull);
        });

    testWidgets('показывает индикатор загрузки и блокирует кнопку при AuthLoading',
            (tester) async {
          when(() => mockCubit.state).thenReturn(const AuthLoading());

          await tester.pumpWidget(buildTestableWidget());

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
          expect(button.onPressed, isNull);
        });

    testWidgets('вызывает login с заполненными полями', (tester) async {
      when(() => mockCubit.state).thenReturn(const AuthInitial());
      when(() => mockCubit.login(any())).thenAnswer((_) async {});

      await tester.pumpWidget(buildTestableWidget());

      await tester.enterText(
          find.widgetWithText(TextField, 'Имя пользователя'), 'myuser');
      await tester.enterText(
          find.widgetWithText(TextField, 'Пароль'), 'mypass');

      await tester.tap(find.text('Войти'));
      await tester.pump();

      final captured = verify(() => mockCubit.login(captureAny())).captured;
      expect(captured.length, 1);
      final credentials = captured[0] as AuthCredentials;
      expect(credentials.username, 'myuser');
      expect(credentials.password, 'mypass');
    });

    testWidgets('не вызывает login, если поля пустые', (tester) async {
      when(() => mockCubit.state).thenReturn(const AuthInitial());

      await tester.pumpWidget(buildTestableWidget());

      await tester.tap(find.text('Войти'));
      await tester.pump();

      verifyNever(() => mockCubit.login(any()));
    });
  });
}