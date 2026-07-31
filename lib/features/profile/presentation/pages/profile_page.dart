import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_platform_example/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:social_platform_example/features/auth/presentation/cubit/auth_state.dart';
import 'package:social_platform_example/features/auth/presentation/pages/auth_page.dart';
import 'package:social_platform_example/features/feed/domain/entities/pin.dart';
import 'package:social_platform_example/features/auth/domain/entities/user.dart';
import 'package:social_platform_example/features/profile/presentation/cubit/liked_pins_cubit.dart';
import 'package:social_platform_example/features/profile/presentation/cubit/liked_pins_state.dart';
import 'package:social_platform_example/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:social_platform_example/features/profile/presentation/cubit/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();
  bool _navigatedToAuth = false;

  @override
  void initState() {
    super.initState();
    // Загружаем профиль и первую страницу лайкнутых пинов
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().getProfile();
      context.read<LikedPinsCubit>().loadFirstPage();
    });
    _scrollController.addListener(_onScroll);
  }

  Future<void> _onRefresh() async {
    await Future.wait([
      context.read<ProfileCubit>().getProfile(),
      context.read<LikedPinsCubit>().loadFirstPage(),
    ]);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<LikedPinsCubit>().loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, authState) {
          if (authState is AuthInitial && !_navigatedToAuth) {
            _navigatedToAuth = true;
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const AuthPage()),
                  (route) => false,
            );
          } else if (authState is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Ошибка: ${authState.message}')),
            );
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, profileState) {
            if (profileState is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (profileState is ProfileError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Ошибка профиля: ${profileState.message}'),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () => context.read<ProfileCubit>().getProfile(),
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              );
            }
            if (profileState is ProfileLoaded) {
              final profile = profileState.profileData;
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    _ProfileHeader(
                      user: profile.user,
                      likesCount: profile.likesCount,
                      onNavigateToFeed: () => Navigator.pop(context),
                    ),
                    const _LikedPinsGrid(),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

// ------------------- вспомогательные виджеты -------------------

class _ProfileHeader extends StatelessWidget {
  final User user;
  final int likesCount;
  final VoidCallback onNavigateToFeed;

  const _ProfileHeader({
    required this.user,
    required this.likesCount,
    required this.onNavigateToFeed,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              children: [
                if (user.avatarUrl != null)
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(user.avatarUrl!),
                  )
                else
                  const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
                const SizedBox(height: 12),
                Text(user.username, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.favorite, color: Colors.red),
                    const SizedBox(width: 4),
                    Text('$likesCount', style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: 16),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                    final isLoading = authState is AuthLoading;
                    return ElevatedButton.icon(
                      onPressed: isLoading ? null : () => context.read<AuthCubit>().logout(),
                      icon: isLoading
                          ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : const Icon(Icons.logout),
                      label: const Text('Выйти'),
                    );
                  },
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: 'Лента',
                onPressed: onNavigateToFeed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LikedPinsGrid extends StatelessWidget {
  const _LikedPinsGrid();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LikedPinsCubit, LikedPinsState>(
      listener: (context, state) {
        // Ошибка первой загрузки
        if (state is LikedPinsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: ${state.message}')),
          );
        }
        // Ошибка пагинации — приходит как LikedPinsLoaded с errorMessage
        if (state is LikedPinsLoaded && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка загрузки: ${state.errorMessage}')),
          );
        }
      },
      builder: (context, state) {
        // Первичная загрузка
        if (state is LikedPinsLoading && (state.pins == null || state.pins!.isEmpty)) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }
        // Ошибка при первой загрузке
        if (state is LikedPinsError) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Ошибка: ${state.message}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => context.read<LikedPinsCubit>().loadFirstPage(),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            ),
          );
        }
        // Подгрузка или полная загрузка с пинами
        List<Pin>? pins;
        bool showLoader = false;
        if (state is LikedPinsLoading && state.pins != null && state.pins!.isNotEmpty) {
          pins = state.pins!;
          showLoader = true;
        } else if (state is LikedPinsLoaded) {
          pins = state.pins;
          if (pins.isEmpty) {
            return const SliverFillRemaining(
              child: Center(
                child: Text(
                  'У вас пока нет понравившихся пинов',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            );
          }
        }
        if (pins == null) return const SliverFillRemaining(child: SizedBox.shrink());

        return SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                if (index < pins!.length) {
                  return _PinCard(pin: pins[index]);
                } else {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
              childCount: pins.length + (showLoader ? 1 : 0),
            ),
          ),
        );
      },
    );
  }
}

class _PinCard extends StatelessWidget {
  final Pin pin;
  const _PinCard({required this.pin});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              pin.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pin.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(pin.author, style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.favorite, size: 16, color: Colors.red),
                    const SizedBox(width: 4),
                    Text('${pin.likesCount}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}