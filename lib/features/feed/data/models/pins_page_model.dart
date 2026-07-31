import 'package:social_platform_example/features/feed/domain/entities/pins_page.dart';
import 'package:social_platform_example/features/feed/data/models/pin_model.dart';

class PinsPageModel {
  final List<PinModel> pins;
  final bool hasMore;
  final int page;

  const PinsPageModel({
    required this.pins,
    required this.hasMore,
    required this.page,
  });

  factory PinsPageModel.fromJson(Map<String, dynamic> json){
    return PinsPageModel(
      pins: (json['pins'] as List<dynamic>)
          .map((e) => PinModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasMore: json['hasMore'] as bool,
      page: json['page'] as int,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'pins': pins.map((e) => e.toJson()).toList(),
      'hasMore': hasMore,
      'page': page,
    };
  }

  PinsPage toEntity(){
    return PinsPage(
      pins: pins.map((x) => x.toEntity()).toList(),
      hasMore: hasMore,
      page: page,
    );
  }

}