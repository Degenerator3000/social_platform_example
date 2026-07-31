import 'package:social_platform_example/features/feed/data/models/pins_page_model.dart';

abstract class FeedDataSource {
  Future<PinsPageModel> fetchPins({required int page, required int limit});
}