import 'package:social_platform_example/features/feed/domain/entities/pins_page.dart';
import 'package:social_platform_example/features/profile/domain/repositories/likes_repository.dart';

class GetLikesUseCase {
  final LikesRepository likesRepository;

  GetLikesUseCase({
    required this.likesRepository,
  });

  Future<PinsPage> call({required int page, required int limit}) async{
    return await likesRepository.getLikes(page: page, limit: limit);
  }
}