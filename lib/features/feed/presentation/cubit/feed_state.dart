import 'package:equatable/equatable.dart';
import 'package:social_platform_example/features/feed/domain/entities/pin.dart';

abstract class FeedState extends Equatable {
  const FeedState();
}

class FeedInitial extends FeedState{
  const FeedInitial();
  @override
  List<Object> get props => [];
}

class FeedLoading extends FeedState {
  final List<Pin>? pins;
  final bool? hasMore;
  final int? currentPage;

  const FeedLoading({
    this.pins,
    this.hasMore,
    this.currentPage,
  });

  @override
  List<Object?> get props => [pins, hasMore, currentPage];
}

class FeedLoaded extends FeedState {
  final List<Pin> pins;
  final bool hasMore;
  final int currentPage;
  final String? errorMessage;

  const FeedLoaded({
    required this.pins,
    required this.hasMore,
    required this.currentPage,
    this.errorMessage,
  });
  @override
  List<Object> get props => [pins, hasMore, currentPage];
}

class FeedError  extends FeedState {
  final String message;
  const FeedError ({required this.message});
  @override
  List<Object> get props => [message];
}