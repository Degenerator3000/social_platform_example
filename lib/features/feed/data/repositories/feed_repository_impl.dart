import 'package:social_platform_example/features/feed/data/datasources/feed_data_source.dart';
import 'package:social_platform_example/features/feed/domain/repositories/feed_repository.dart';
import 'package:social_platform_example/features/feed/domain/entities/pins_page.dart';

class FeedRepositoryImpl implements FeedRepository{
  final FeedDataSource feedDataSource;

  const FeedRepositoryImpl(this.feedDataSource);

  @override
  Future<PinsPage> getPins({required int page, required int limit}) async{
    final pinsPageModel = await feedDataSource.fetchPins(page: page, limit: limit);
    return pinsPageModel.toEntity();
  }
}