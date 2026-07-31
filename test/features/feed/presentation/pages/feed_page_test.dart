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
      imageUrl: 'https://picsum.photos/400/600',
      title: 'Test Pin 1',
      author: 'Author 1',
      likesCount: 10,
    ),
    Pin(
      id: '2',
      imageUrl: 'https://picsum.photos/400/601',
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
        home: const FeedPage(),
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
    when(() => mockProfileCubit.state).thenReturn(const ProfileInitial());
    when(() => mockProfileCubit.getProfile()).thenAnswer((_) async {});

    when(() => mockLikedPinsCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockLikedPinsCubit.isClosed).thenReturn(false);
    when(() => mockLikedPinsCubit.state).thenReturn(const LikedPinsInitial());
    when(() => mockLikedPinsCubit.loadFirstPage()).thenAnswer((_) async {});

    when(() => mockFeedCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockFeedCubit.isClosed).thenReturn(false);
    when(() => mockFeedCubit.loadFirstPage()).thenAnswer((_) async {});
  });

  group('FeedPage', () {
    testWidgets('показывает индикатор загрузки при FeedLoading без пинов',
            (WidgetTester tester) async {
          when(() => mockFeedCubit.state).thenReturn(const FeedLoading());
          await tester.pumpWidget(buildTestableWidget());
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        });

    testWidgets('показывает ошибку и кнопку повтора при FeedError',
            (WidgetTester tester) async {
          const errorMsg = 'Ошибка сети';
          when(() => mockFeedCubit.state)
              .thenReturn(const FeedError(message: errorMsg));
          await tester.pumpWidget(buildTestableWidget());
          expect(find.text('Ошибка: $errorMsg'), findsOneWidget);
          expect(find.widgetWithText(ElevatedButton, 'Повторить'), findsOneWidget);
        });

    testWidgets('отображает пустое сообщение при FeedLoaded с пустым списком',
            (WidgetTester tester) async {
          when(() => mockFeedCubit.state)
              .thenReturn(const FeedLoaded(pins: [], hasMore: false, currentPage: 1));
          await tester.pumpWidget(buildTestableWidget());
          expect(find.text('Пинов пока нет'), findsOneWidget);
        });

    testWidgets('отображает сетку с пинами при FeedLoaded',
            (WidgetTester tester) async {
          when(() => mockFeedCubit.state)
              .thenReturn(FeedLoaded(pins: testPins, hasMore: false, currentPage: 1));
          await tester.pumpWidget(buildTestableWidget());
          expect(find.text('Test Pin 1'), findsOneWidget);
          expect(find.text('Test Pin 2'), findsOneWidget);
          expect(find.byType(Card), findsNWidgets(2));
        });

    testWidgets('показывает индикатор внизу при FeedLoading с пинами (дозагрузка)',
            (WidgetTester tester) async {
          when(() => mockFeedCubit.state)
              .thenReturn(FeedLoading(pins: testPins, hasMore: true, currentPage: 1));
          await tester.pumpWidget(buildTestableWidget());
          expect(find.text('Test Pin 1'), findsOneWidget);
          expect(find.text('Test Pin 2'), findsOneWidget);
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        });

    testWidgets('показывает AppBar с заголовком "Лента"',
            (WidgetTester tester) async {
          when(() => mockFeedCubit.state)
              .thenReturn(const FeedLoaded(pins: [], hasMore: false, currentPage: 1));
          await tester.pumpWidget(buildTestableWidget());
          expect(find.text('Лента'), findsOneWidget);
        });

    testWidgets('показывает кнопку профиля в AppBar',
            (WidgetTester tester) async {
          when(() => mockFeedCubit.state)
              .thenReturn(const FeedLoaded(pins: [], hasMore: false, currentPage: 1));
          await tester.pumpWidget(buildTestableWidget());
          expect(find.byIcon(Icons.person), findsOneWidget);
        });

    testWidgets('нажатие кнопки профиля открывает ProfilePage',
            (WidgetTester tester) async {
          when(() => mockFeedCubit.state)
              .thenReturn(const FeedLoaded(pins: [], hasMore: false, currentPage: 1));
          when(() => mockProfileCubit.state)
              .thenReturn(ProfileLoaded(profileData: testProfileData));
          when(() => mockLikedPinsCubit.state)
              .thenReturn(const LikedPinsLoaded(pins: [], hasMore: false, currentPage: 1));

          await tester.pumpWidget(buildTestableWidget());

          await tester.tap(find.byIcon(Icons.person));
          await tester.pumpAndSettle();

          expect(find.text('testuser'), findsOneWidget);
          expect(find.byIcon(Icons.arrow_back), findsOneWidget);
        });

    testWidgets('возврат из профиля сохраняет ленту без перезагрузки',
            (WidgetTester tester) async {
          when(() => mockFeedCubit.state)
              .thenReturn(FeedLoaded(pins: testPins, hasMore: false, currentPage: 1));
          when(() => mockProfileCubit.state)
              .thenReturn(ProfileLoaded(profileData: testProfileData));
          when(() => mockLikedPinsCubit.state)
              .thenReturn(const LikedPinsLoaded(pins: [], hasMore: false, currentPage: 1));

          await tester.pumpWidget(buildTestableWidget());

          await tester.tap(find.byIcon(Icons.person));
          await tester.pumpAndSettle();

          await tester.tap(find.byIcon(Icons.arrow_back));
          await tester.pumpAndSettle();

          expect(find.text('Лента'), findsOneWidget);
          expect(find.text('Test Pin 1'), findsOneWidget);
          expect(find.text('Test Pin 2'), findsOneWidget);
        });
  });
}