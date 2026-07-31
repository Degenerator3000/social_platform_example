import 'package:equatable/equatable.dart';
import 'package:social_platform_example/features/feed/domain/entities/pin.dart';

class PinsPage extends Equatable{
  final List<Pin> pins;
  final bool hasMore;
  final int page;

  const PinsPage({
    required this.pins,
    required this.hasMore,
    required this.page,
  });


  @override
  List<Object?> get props => [pins, hasMore, page];
}