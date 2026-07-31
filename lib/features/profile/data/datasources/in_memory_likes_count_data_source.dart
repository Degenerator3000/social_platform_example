import 'likes_count_data_source.dart';

class InMemoryLikesCountDataSource implements LikesCountDataSource{

  late final likesCount = 100;

  @override
  Future<int> getLikesCount() async{
    await Future.delayed(Duration(seconds: 1));
    return likesCount;
  }

}