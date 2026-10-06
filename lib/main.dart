import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_platform_example/core/di/injection_container.dart';
import 'package:social_platform_example/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_platform_example/features/feed/presentation/cubit/feed_cubit.dart';
import 'package:social_platform_example/features/auth/presentation/pages/auth_page.dart';
import 'package:social_platform_example/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:social_platform_example/features/profile/presentation/cubit/liked_pins_cubit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();

  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(
            loginUseCase: sl(),
            logoutUseCase: sl(),
            checkAuthUseCase: sl(),
          ),
        ),
        BlocProvider<FeedCubit>(
          create: (_) => sl<FeedCubit>(),
        ),
        BlocProvider<ProfileCubit>(
            create: (_) => sl<ProfileCubit>()
        ),
        BlocProvider<LikedPinsCubit>(
          create: (_) => sl<LikedPinsCubit>(),
        ),
      ],
      child: MaterialApp(
        home: const AuthPage(),
      ),
    );
  }
}