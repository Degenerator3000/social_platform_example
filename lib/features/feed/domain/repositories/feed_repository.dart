import 'dart:async';
import 'package:social_platform_example/features/feed/domain/entities/pins_page.dart';

//интерфейс для получения пинов из базы данных
//реализация Dependency Inversion, Single responsibility
abstract class FeedRepository {
  Future<PinsPage> getPins({required int page, required int limit});
}