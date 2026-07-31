import 'package:get_it/get_it.dart';
import 'package:social_platform_example/features/feed/data/datasources/feed_data_source.dart';
import 'package:social_platform_example/features/feed/data/datasources/in_memory_data_source.dart';
import 'package:social_platform_example/features/feed/data/repositories/feed_repository_impl.dart';
import 'package:social_platform_example/features/feed/domain/repositories/feed_repository.dart';
import 'package:social_platform_example/features/feed/domain/usecases/get_pins_use_case.dart';
import 'package:social_platform_example/core/security/secure_storage_service.dart';
import 'package:social_platform_example/features/auth/data/datasources/secure_storage_token_source.dart';
import 'package:social_platform_example/features/auth/data/datasources/token_data_source.dart';
import 'package:social_platform_example/features/auth/data/datasources/auth_data_source.dart';
import 'package:social_platform_example/features/auth/data/datasources/in_memory_data_source.dart';
import 'package:social_platform_example/features/auth/domain/repositories/auth_repository.dart';
import 'package:social_platform_example/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:social_platform_example/features/auth/domain/usecases/login_use_case.dart';
import 'package:social_platform_example/features/auth/domain/usecases/logout_use_case.dart';
import 'package:social_platform_example/features/auth/domain/usecases/check_auth_use_case.dart';
import 'package:social_platform_example/features/feed/presentation/cubit/feed_cubit.dart';
import 'package:social_platform_example/features/profile/data/datasources/likes_data_source.dart';
import 'package:social_platform_example/features/profile/data/datasources/likes_count_data_source.dart';
import 'package:social_platform_example/features/profile/data/datasources/in_memory_likes_data_source.dart';
import 'package:social_platform_example/features/profile/data/datasources/in_memory_likes_count_data_source.dart';
import 'package:social_platform_example/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:social_platform_example/features/profile/domain/repositories/profile_repository.dart';
import 'package:social_platform_example/features/profile/data/repositories/likes_repository_impl.dart';
import 'package:social_platform_example/features/profile/domain/repositories/likes_repository.dart';
import 'package:social_platform_example/features/profile/domain/usecases/get_likes_use_case.dart';
import 'package:social_platform_example/features/profile/domain/usecases/get_profile_use_case.dart';
import 'package:social_platform_example/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:social_platform_example/features/profile/presentation/cubit/liked_pins_cubit.dart';

final sl = GetIt.instance;   //глобальный экземпляр локатора

Future<void> setupDependencies() async {
  //Data sources – регистрируем как интерфейс
  sl.registerLazySingleton<FeedDataSource>(
        () => InMemoryDataSource(),
  );

  //Репозиторий – зависит от FeedDataSource
  sl.registerLazySingleton<FeedRepository>(
        () => FeedRepositoryImpl(sl()),
  );

  //Use cases
  sl.registerLazySingleton(
        () => GetPinsUseCase(feedRepository: sl()),
  );

  sl.registerLazySingleton<SecureStorageService>(
          () => SecureStorageService(),
  );

  sl.registerLazySingleton<TokenDataSource>(
    () => SecureStorageTokenSource(secureStorage: sl<SecureStorageService>()),
  );

  sl.registerLazySingleton<AuthDataSource>(
          () => InMemoryAuthDataSource()
  );

  sl.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      authDataSource: sl(),
      tokenDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<FeedCubit>(
        () => FeedCubit(
            getPinsUseCase: sl(),
            firstPageLimit: 8,
            nextPageLimit: 4,
        ),
  );

  sl.registerLazySingleton(() => LoginUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => LogoutUseCase(authRepository: sl()));
  sl.registerLazySingleton(() => CheckAuthUseCase(authRepository: sl()));

  sl.registerLazySingleton<LikesDataSource>(
        () => InMemoryLikesDataSource(),
  );

  sl.registerLazySingleton<LikesCountDataSource>(
        () => InMemoryLikesCountDataSource(),
  );

  sl.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(
            likesCountDataSource: sl(),
            authRepository: sl(),
        ),
  );

  sl.registerLazySingleton<LikesRepository>(
        () => LikesRepositoryImpl(likesDataSource: sl()));

  sl.registerLazySingleton(() => GetLikesUseCase(likesRepository: sl()));
  sl.registerLazySingleton(() => GetProfileUseCase(profileRepository: sl()));

  sl.registerLazySingleton<ProfileCubit>(
        () => ProfileCubit(getProfileUseCase: sl()),
  );

  sl.registerFactory<LikedPinsCubit>(
        () => LikedPinsCubit(
            getLikesUseCase: sl(),
            firstPageLimit: 6,
            nextPageLimit: 4,
        ),);
}

