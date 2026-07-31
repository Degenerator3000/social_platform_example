import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:social_platform_example/features/feed/domain/entities/pin.dart';
import 'package:social_platform_example/features/feed/domain/entities/pins_page.dart';
import 'package:social_platform_example/features/feed/domain/usecases/get_pins_use_case.dart';
import 'package:social_platform_example/features/feed/presentation/cubit/feed_cubit.dart';
import 'package:social_platform_example/features/feed/presentation/cubit/feed_state.dart';

import 'feed_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetPinsUseCase>()])
void main() {
  late MockGetPinsUseCase mockGetPinsUseCase;

  final pin1 = Pin(
    id: '1',
    imageUrl: 'https://example.com/1.jpg',
    title: 'Pin 1',
    author: 'Author 1',
    likesCount: 10,
    description: null,
  );
  final pin2 = Pin(
    id: '2',
    imageUrl: 'https://example.com/2.jpg',
    title: 'Pin 2',
    author: 'Author 2',
    likesCount: 20,
    description: null,
  );
  final pin3 = Pin(
    id: '3',
    imageUrl: 'https://example.com/3.jpg',
    title: 'Pin 3',
    author: 'Author 3',
    likesCount: 30,
    description: null,
  );

  final firstPagePins = [pin1, pin2];
  final secondPagePins = [pin3];

  final firstPage = PinsPage(pins: firstPagePins, hasMore: true, page: 1);
  final secondPage = PinsPage(pins: secondPagePins, hasMore: false, page: 2);

  const firstPageLimit = 2;
  const nextPageLimit = 2;

  setUp(() {
    mockGetPinsUseCase = MockGetPinsUseCase();
  });

  group('loadFirstPage', () {
    blocTest<FeedCubit, FeedState>(
      'должен испускать [FeedLoading, FeedLoaded] при успешной загрузке',
      build: () => FeedCubit(
        getPinsUseCase: mockGetPinsUseCase,
        firstPageLimit: firstPageLimit,
        nextPageLimit: nextPageLimit,
      ),
      setUp: () {
        when(mockGetPinsUseCase(page: 1, limit: firstPageLimit))
            .thenAnswer((_) async => firstPage);
      },
      act: (cubit) => cubit.loadFirstPage(),
      expect: () => [
        isA<FeedLoading>(),
        isA<FeedLoaded>(),
      ],
      verify: (_) {
        verify(mockGetPinsUseCase(page: 1, limit: firstPageLimit)).called(1);
      },
    );

    blocTest<FeedCubit, FeedState>(
      'должен испускать [FeedLoading, FeedError] при ошибке загрузки',
      build: () => FeedCubit(
        getPinsUseCase: mockGetPinsUseCase,
        firstPageLimit: firstPageLimit,
        nextPageLimit: nextPageLimit,
      ),
      setUp: () {
        when(mockGetPinsUseCase(page: 1, limit: firstPageLimit))
            .thenThrow(Exception('Сетевая ошибка'));
      },
      act: (cubit) => cubit.loadFirstPage(),
      expect: () => [
        isA<FeedLoading>(),
        isA<FeedError>(),
      ],
      verify: (_) {
        verify(mockGetPinsUseCase(page: 1, limit: firstPageLimit)).called(1);
      },
    );
  });

  group('loadNextPage', () {
    blocTest<FeedCubit, FeedState>(
      'должен добавить пины и испустить [FeedLoading с пинами, FeedLoaded] при успешной дозагрузке',
      build: () => FeedCubit(
        getPinsUseCase: mockGetPinsUseCase,
        firstPageLimit: firstPageLimit,
        nextPageLimit: nextPageLimit,
      ),
      setUp: () {
        when(mockGetPinsUseCase(page: 1, limit: firstPageLimit))
            .thenAnswer((_) async => firstPage);
        when(mockGetPinsUseCase(page: 2, limit: nextPageLimit))
            .thenAnswer((_) async => secondPage);
      },
      act: (cubit) async {
        await cubit.loadFirstPage();
        await cubit.loadNextPage();
      },
      expect: () => [
        isA<FeedLoading>(),
        isA<FeedLoaded>(),
        isA<FeedLoading>(),
        isA<FeedLoaded>(),
      ],
      verify: (_) {
        verify(mockGetPinsUseCase(page: 1, limit: firstPageLimit)).called(1);
        verify(mockGetPinsUseCase(page: 2, limit: nextPageLimit)).called(1);
      },
    );

    blocTest<FeedCubit, FeedState>(
      'должен эмитить FeedLoaded с errorMessage при ошибке дозагрузки',
      build: () => FeedCubit(
        getPinsUseCase: mockGetPinsUseCase,
        firstPageLimit: firstPageLimit,
        nextPageLimit: nextPageLimit,
      ),
      setUp: () {
        when(mockGetPinsUseCase(page: 1, limit: firstPageLimit))
            .thenAnswer((_) async => firstPage);
        when(mockGetPinsUseCase(page: 2, limit: nextPageLimit))
            .thenThrow(Exception('Сетевая ошибка'));
      },
      act: (cubit) async {
        await cubit.loadFirstPage();
        await cubit.loadNextPage();
      },
      expect: () => [
        isA<FeedLoading>(),
        isA<FeedLoaded>(),
        isA<FeedLoading>(),
        isA<FeedLoaded>(),
      ],
      verify: (_) {
        verify(mockGetPinsUseCase(page: 1, limit: firstPageLimit)).called(1);
        verify(mockGetPinsUseCase(page: 2, limit: nextPageLimit)).called(1);
      },
    );

    blocTest<FeedCubit, FeedState>(
      'не должен загружать следующую страницу, если hasMore == false',
      build: () => FeedCubit(
        getPinsUseCase: mockGetPinsUseCase,
        firstPageLimit: firstPageLimit,
        nextPageLimit: nextPageLimit,
      ),
      setUp: () {
        final noMorePage = PinsPage(pins: firstPagePins, hasMore: false, page: 1);
        when(mockGetPinsUseCase(page: 1, limit: firstPageLimit))
            .thenAnswer((_) async => noMorePage);
      },
      act: (cubit) async {
        await cubit.loadFirstPage();
        await cubit.loadNextPage();
      },
      expect: () => [
        isA<FeedLoading>(),
        isA<FeedLoaded>(),
      ],
      verify: (_) {
        verify(mockGetPinsUseCase(page: 1, limit: firstPageLimit)).called(1);
        verifyNever(mockGetPinsUseCase(page: 2, limit: anyNamed('limit')));
      },
    );
  });
}