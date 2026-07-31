import 'package:social_platform_example/features/profile/domain/repositories/likes_repository.dart';
import 'package:social_platform_example/features/feed/domain/entities/pins_page.dart';
import 'package:social_platform_example/features/profile/data/datasources/likes_data_source.dart';

class LikesRepositoryImpl implements LikesRepository{

  final LikesDataSource likesDataSource;

  LikesRepositoryImpl({
    required this.likesDataSource,
  });

  @override
  Future<PinsPage> getLikes({required int page, required int limit}) async{
    final likesPageModel = await likesDataSource.getLikes(page: page, limit: limit);
    return likesPageModel.toEntity();
  }

}