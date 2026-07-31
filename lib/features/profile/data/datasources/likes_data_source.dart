import 'package:social_platform_example/features/profile/data/models/likes_page_model.dart';

abstract class LikesDataSource {

  Future<LikesPageModel> getLikes({required int page, required int limit});

}