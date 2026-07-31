import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:social_platform_example/features/auth/domain/entities/user.dart';
import 'package:social_platform_example/features/profile/domain/entities/profile_data.dart';
import 'package:social_platform_example/features/profile/domain/usecases/get_profile_use_case.dart';
import 'package:social_platform_example/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:social_platform_example/features/profile/presentation/cubit/profile_state.dart';

import 'profile_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetProfileUseCase>()])
void main() {
  late MockGetProfileUseCase mockGetProfileUseCase;

  final testUser = User(id: '1', username: 'testuser', avatarUrl: null);
  final testProfileData = ProfileData(user: testUser, likesCount: 42);

  setUp(() {
    mockGetProfileUseCase = MockGetProfileUseCase();
  });

  group('getProfile', () {
    blocTest<ProfileCubit, ProfileState>(
      'должен испускать [ProfileLoading, ProfileLoaded] при успешной загрузке',
      build: () => ProfileCubit(getProfileUseCase: mockGetProfileUseCase),
      setUp: () {
        when(mockGetProfileUseCase()).thenAnswer((_) async => testProfileData);
      },
      act: (cubit) => cubit.getProfile(),
      expect: () => [
        const ProfileLoading(),
        ProfileLoaded(profileData: testProfileData),
      ],
      verify: (_) {
        verify(mockGetProfileUseCase()).called(1);
      },
    );

    blocTest<ProfileCubit, ProfileState>(
      'должен испускать [ProfileLoading, ProfileError] при ошибке загрузки',
      build: () => ProfileCubit(getProfileUseCase: mockGetProfileUseCase),
      setUp: () {
        when(mockGetProfileUseCase()).thenThrow(Exception('Сервер недоступен'));
      },
      act: (cubit) => cubit.getProfile(),
      expect: () => [
        const ProfileLoading(),
        const ProfileError(message: 'Exception: Сервер недоступен'),
      ],
      verify: (_) {
        verify(mockGetProfileUseCase()).called(1);
      },
    );
  });
}