import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:social_platform_example/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_platform_example/features/auth/presentation/cubit/auth_state.dart';
import 'package:social_platform_example/features/auth/domain/entities/user.dart';
import 'package:social_platform_example/features/feed/domain/entities/pin.dart';
import 'package:social_platform_example/features/feed/presentation/cubit/feed_cubit.dart';
import 'package:social_platform_example/features/feed/presentation/cubit/feed_state.dart';
import 'package:social_platform_example/features/feed/presentation/pages/feed_page.dart';
import 'package:social_platform_example/features/profile/presentation/cubit/liked_pins_cubit.dart';
import 'package:social_platform_example/features/profile/presentation/cubit/liked_pins_state.dart';
import 'package:social_platform_example/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:social_platform_example/features/profile/presentation/cubit/profile_state.dart';
import 'package:social_platform_example/features/profile/domain/entities/profile_data.dart';
import 'package:social_platform_example/features/profile/presentation/pages/profile_page.dart';

class MockAuthCubit extends Mock implements AuthCubit {}
class MockProfileCubit extends Mock implements ProfileCubit {}
class MockLikedPinsCubit extends Mock implements LikedPinsCubit {}
class MockFeedCubit extends Mock implements FeedCubit {}

void main() {
  late MockAuthCubit mockAuthCubit;
  late MockProfileCubit mockProfileCubit;
  late MockLikedPinsCubit mockLikedPinsCubit;
  late MockFeedCubit mockFeedCubit;

  final testUser = User(
    id: '1',
    username: 'testuser',
    avatarUrl: null,
  );
  final testProfileData = ProfileData(user: testUser, likesCount: 42);

  final testPins = [
    Pin(
      id: '1',
      imageUrl: 'https://example.com/images/pin1.jpg',
      title: 'Test Pin 1',
      author: 'Author 1',
      likesCount: 10,
    ),
    Pin(
      id: '2',
      imageUrl: 'https://example.com/images/pin2.jpg',
      title: 'Test Pin 2',
      author: 'Author 2',
      likesCount: 20,
    ),
  ];

  Widget buildTestableWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: mockAuthCubit),
        BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
        BlocProvider<LikedPinsCubit>.value(value: mockLikedPinsCubit),
        BlocProvider<FeedCubit>.value(value: mockFeedCubit),
      ],
      child: MaterialApp(
        home: const ProfilePage(),
      ),
    );
  }

  setUp(() {
    mockAuthCubit = MockAuthCubit();
    mockProfileCubit = MockProfileCubit();
    mockLikedPinsCubit = MockLikedPinsCubit();
    mockFeedCubit = MockFeedCubit();

    registerFallbackValue(const AuthInitial());
    registerFallbackValue(const ProfileInitial());
    registerFallbackValue(const LikedPinsInitial());
    registerFallbackValue(const FeedInitial());

    when(() => mockAuthCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockAuthCubit.isClosed).thenReturn(false);
    when(() => mockAuthCubit.state).thenReturn(const AuthInitial());

    when(() => mockProfileCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockProfileCubit.isClosed).thenReturn(false);
    when(() => mockProfileCubit.getProfile()).thenAnswer((_) async {});

    when(() => mockLikedPinsCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockLikedPinsCubit.isClosed).thenReturn(false);
    when(() => mockLikedPinsCubit.loadFirstPage()).thenAnswer((_) async {});

    when(() => mockFeedCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockFeedCubit.isClosed).thenReturn(false);
    when(() => mockFeedCubit.state).thenReturn(const FeedInitial());
    when(() => mockFeedCubit.loadFirstPage()).thenAnswer((_) async {});
  });

  group('ProfilePage', () {
    testWidgets('показывает индикатор загрузки при ProfileLoading',
            (WidgetTester tester) async {
          when(() => mockProfileCubit.state).thenReturn(const ProfileLoading());
          await tester.pumpWidget(buildTestableWidget());
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        });

    testWidgets('показывает ошибку профиля и кнопку повтора при ProfileError',
            (WidgetTester tester) async {
          const errorMsg = 'Ошибка загрузки профиля';
          when(() => mockProfileCubit.state)
              .thenReturn(const ProfileError(message: errorMsg));
          await tester.pumpWidget(buildTestableWidget());
          expect(find.text('Ошибка профиля: $errorMsg'), findsOneWidget);
          expect(find.widgetWithText(ElevatedButton, 'Повторить'), findsOneWidget);
        });

    testWidgets(
        'отображает профиль, кнопки и сообщение о пустых пинах при ProfileLoaded и пустом списке',
            (WidgetTester tester) async {
          when(() => mockProfileCubit.state)
              .thenReturn(ProfileLoaded(profileData: testProfileData));
          when(() => mockLikedPinsCubit.state)
              .thenReturn(const LikedPinsLoaded(pins: [], hasMore: false, currentPage: 1));

          await tester.pumpWidget(buildTestableWidget());

          expect(find.text('testuser'), findsOneWidget);
          expect(find.text('42'), findsOneWidget);
          expect(find.byType(CircleAvatar), findsOneWidget);
          expect(find.widgetWithText(ElevatedButton, 'Выйти'), findsOneWidget);
          expect(find.byIcon(Icons.arrow_back), findsOneWidget);
          expect(find.text('У вас пока нет понравившихся пинов'), findsOneWidget);
        });

    testWidgets('отображает сетку с пинами при LikedPinsLoaded',
            (WidgetTester tester) async {
          when(() => mockProfileCubit.state)
              .thenReturn(ProfileLoaded(profileData: testProfileData));
          when(() => mockLikedPinsCubit.state)
              .thenReturn(LikedPinsLoaded(pins: testPins, hasMore: false, currentPage: 1));

          await tester.pumpWidget(buildTestableWidget());

          expect(find.text('Test Pin 1'), findsOneWidget);
          expect(find.text('Test Pin 2'), findsOneWidget);
          expect(find.byType(Card), findsNWidgets(2));
        });

    testWidgets(
        'показывает индикатор загрузки пинов при LikedPinsLoading без данных',
            (WidgetTester tester) async {
          when(() => mockProfileCubit.state)
              .thenReturn(ProfileLoaded(profileData: testProfileData));
          when(() => mockLikedPinsCubit.state)
              .thenReturn(const LikedPinsLoading());

          await tester.pumpWidget(buildTestableWidget());

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        });

    testWidgets('показывает ошибку пинов и кнопку повтора при LikedPinsError',
            (WidgetTester tester) async {
          when(() => mockProfileCubit.state)
              .thenReturn(ProfileLoaded(profileData: testProfileData));
          when(() => mockLikedPinsCubit.state)
              .thenReturn(const LikedPinsError(message: 'Ошибка сети'));

          await tester.pumpWidget(buildTestableWidget());

          expect(find.text('Ошибка: Ошибка сети'), findsOneWidget);
          expect(find.widgetWithText(ElevatedButton, 'Повторить'), findsOneWidget);
        });

    testWidgets('нажатие кнопки "Выйти" вызывает logout()',
            (WidgetTester tester) async {
          when(() => mockAuthCubit.state)
              .thenReturn(AuthAuthenticated(user: testUser));
          when(() => mockAuthCubit.logout()).thenAnswer((_) async {});

          when(() => mockProfileCubit.state)
              .thenReturn(ProfileLoaded(profileData: testProfileData));
          when(() => mockLikedPinsCubit.state)
              .thenReturn(const LikedPinsLoaded(pins: [], hasMore: false, currentPage: 1));

          await tester.pumpWidget(buildTestableWidget());
          await tester.tap(find.widgetWithText(ElevatedButton, 'Выйти'));

          verify(() => mockAuthCubit.logout()).called(1);
        });

    testWidgets('нажатие кнопки назад возвращает на ленту',
            (WidgetTester tester) async {
          when(() => mockProfileCubit.state)
              .thenReturn(ProfileLoaded(profileData: testProfileData));
          when(() => mockLikedPinsCubit.state)
              .thenReturn(const LikedPinsLoaded(pins: [], hasMore: false, currentPage: 1));
          when(() => mockFeedCubit.state)
              .thenReturn(const FeedLoaded(pins: [], hasMore: false, currentPage: 1));

          await tester.pumpWidget(
            MultiBlocProvider(
              providers: [
                BlocProvider<AuthCubit>.value(value: mockAuthCubit),
                BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
                BlocProvider<LikedPinsCubit>.value(value: mockLikedPinsCubit),
                BlocProvider<FeedCubit>.value(value: mockFeedCubit),
              ],
              child: MaterialApp(
                home: const FeedPage(),
              ),
            ),
          );

          await tester.tap(find.byIcon(Icons.person));
          await tester.pumpAndSettle();

          expect(find.text('testuser'), findsOneWidget);
          expect(find.byIcon(Icons.arrow_back), findsOneWidget);

          await tester.tap(find.byIcon(Icons.arrow_back));
          await tester.pumpAndSettle();

          expect(find.text('Лента'), findsOneWidget);
        });
  });
}