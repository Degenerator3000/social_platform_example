import 'dart:async';
import 'package:social_platform_example/features/feed/domain/entities/pins_page.dart';

abstract class LikesRepository {
  Future<PinsPage> getLikes({required int page, required int limit});
}