import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_platform_example/features/feed/presentation/cubit/feed_cubit.dart';
import 'package:social_platform_example/features/feed/presentation/cubit/feed_state.dart';
import 'package:social_platform_example/features/feed/domain/entities/pin.dart';
import 'package:social_platform_example/features/profile/presentation/pages/profile_page.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FeedCubit>().loadFirstPage();
    });
    _scrollController.addListener(_onScroll);
  }

  Future<void> _onRefresh() async {
    await context.read<FeedCubit>().loadFirstPage();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<FeedCubit>().loadNextPage();
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
      appBar: AppBar(
        title: const Text('Лента'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Профиль',
            // pushReplacement уничтожает FeedPage, освобождая память
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            ),
          ),
        ],
      ),
      body: BlocConsumer<FeedCubit, FeedState>(
        listener: (context, state) {
          if (state is FeedLoaded && state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Ошибка загрузки: ${state.errorMessage}')),
            );
          }
        },
        builder: (context, state) {
          // Первичная загрузка
          if (state is FeedLoading && (state.pins == null || state.pins!.isEmpty)) {
            return const Center(child: CircularProgressIndicator());
          }
          // Ошибка первой загрузки
          if (state is FeedError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Ошибка: ${state.message}'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => context.read<FeedCubit>().loadFirstPage(),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }
          // Подгрузка или полная загрузка с пинами
          List<Pin> pins;
          bool showLoader = false;
          if (state is FeedLoading && state.pins != null && state.pins!.isNotEmpty) {
            pins = state.pins!;
            showLoader = true;
          } else if (state is FeedLoaded) {
            pins = state.pins;
            if (pins.isEmpty) {
              return const Center(
                child: Text(
                  'Пинов пока нет',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }
          } else {
            return const SizedBox.shrink();
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: GridView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              // Увеличенный padding снизу — защита от системной навигации
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: pins.length + (showLoader ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < pins.length) {
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
            ),
          );
        },
      ),
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