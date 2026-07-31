import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:social_platform_example/features/feed/domain/entities/pin.dart';
import 'package:social_platform_example/features/feed/domain/entities/pins_page.dart';
import 'package:social_platform_example/features/profile/domain/usecases/get_likes_use_case.dart';
import 'package:social_platform_example/features/profile/presentation/cubit/liked_pins_cubit.dart';
import 'package:social_platform_example/features/profile/presentation/cubit/liked_pins_state.dart';

import 'liked_pins_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetLikesUseCase>()])
void main() {
  late MockGetLikesUseCase mockGetLikesUseCase;

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
    mockGetLikesUseCase = MockGetLikesUseCase();
  });

  group('loadFirstPage', () {
    blocTest<LikedPinsCubit, LikedPinsState>(
      'должен испускать [LikedPinsLoading, LikedPinsLoaded] при успешной загрузке',
      build: () => LikedPinsCubit(
        getLikesUseCase: mockGetLikesUseCase,
        firstPageLimit: firstPageLimit,
        nextPageLimit: nextPageLimit,
      ),
      setUp: () {
        when(mockGetLikesUseCase(page: 1, limit: firstPageLimit))
            .thenAnswer((_) async => firstPage);
      },
      act: (cubit) => cubit.loadFirstPage(),
      expect: () => [
        const LikedPinsLoading(),
        isA<LikedPinsLoaded>(),
      ],
      verify: (_) {
        verify(mockGetLikesUseCase(page: 1, limit: firstPageLimit)).called(1);
      },
    );

    blocTest<LikedPinsCubit, LikedPinsState>(
      'должен испускать [LikedPinsLoading, LikedPinsError] при ошибке загрузки',
      build: () => LikedPinsCubit(
        getLikesUseCase: mockGetLikesUseCase,
        firstPageLimit: firstPageLimit,
        nextPageLimit: nextPageLimit,
      ),
      setUp: () {
        when(mockGetLikesUseCase(page: 1, limit: firstPageLimit))
            .thenThrow(Exception('Сетевая ошибка'));
      },
      act: (cubit) => cubit.loadFirstPage(),
      expect: () => [
        const LikedPinsLoading(),
        isA<LikedPinsError>(),
      ],
      verify: (_) {
        verify(mockGetLikesUseCase(page: 1, limit: firstPageLimit)).called(1);
      },
    );
  });

  group('loadNextPage', () {
    blocTest<LikedPinsCubit, LikedPinsState>(
      'должен добавить пины и испустить [LikedPinsLoading с пинами, LikedPinsLoaded] при успешной дозагрузке',
      build: () => LikedPinsCubit(
        getLikesUseCase: mockGetLikesUseCase,
        firstPageLimit: firstPageLimit,
        nextPageLimit: nextPageLimit,
      ),
      setUp: () {
        when(mockGetLikesUseCase(page: 1, limit: firstPageLimit))
            .thenAnswer((_) async => firstPage);
        when(mockGetLikesUseCase(page: 2, limit: nextPageLimit))
            .thenAnswer((_) async => secondPage);
      },
      act: (cubit) async {
        await cubit.loadFirstPage();
        await cubit.loadNextPage();
      },
      expect: () => [
        isA<LikedPinsLoading>(),
        isA<LikedPinsLoaded>(),
        isA<LikedPinsLoading>(),
        isA<LikedPinsLoaded>(),
      ],
      verify: (_) {
        verify(mockGetLikesUseCase(page: 1, limit: firstPageLimit)).called(1);
        verify(mockGetLikesUseCase(page: 2, limit: nextPageLimit)).called(1);
      },
    );

    blocTest<LikedPinsCubit, LikedPinsState>(
      'не должен загружать следующую страницу, если hasMore == false',
      build: () => LikedPinsCubit(
        getLikesUseCase: mockGetLikesUseCase,
        firstPageLimit: firstPageLimit,
        nextPageLimit: nextPageLimit,
      ),
      setUp: () {
        final noMorePage = PinsPage(pins: firstPagePins, hasMore: false, page: 1);
        when(mockGetLikesUseCase(page: 1, limit: firstPageLimit))
            .thenAnswer((_) async => noMorePage);
      },
      act: (cubit) async {
        await cubit.loadFirstPage();
        await cubit.loadNextPage();
      },
      expect: () => [
        isA<LikedPinsLoading>(),
        isA<LikedPinsLoaded>(),
      ],
      verify: (_) {
        verify(mockGetLikesUseCase(page: 1, limit: firstPageLimit)).called(1);
        verifyNever(mockGetLikesUseCase(page: 2, limit: anyNamed('limit')));
      },
    );
  });
}