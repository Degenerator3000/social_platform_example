import 'package:social_platform_example/features/feed/domain/repositories/feed_repository.dart';
import 'package:social_platform_example/features/feed/domain/entities/pins_page.dart';

class GetPinsUseCase {
  final FeedRepository feedRepository;

  GetPinsUseCase({
    required this.feedRepository,
  });

  Future<PinsPage> call({required int page, required int limit}) async{
    return await feedRepository.getPins(page: page, limit: limit);
  }
}