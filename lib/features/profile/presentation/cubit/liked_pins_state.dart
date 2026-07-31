import 'package:equatable/equatable.dart';
import 'package:social_platform_example/features/feed/domain/entities/pin.dart';

abstract class LikedPinsState extends Equatable {
  const LikedPinsState();
}

class LikedPinsInitial extends LikedPinsState{
  const LikedPinsInitial();
  @override
  List<Object> get props => [];
}

class LikedPinsLoading extends LikedPinsState {
  final List<Pin>? pins;
  final bool? hasMore;
  final int? currentPage;

  const LikedPinsLoading({
    this.pins,
    this.hasMore,
    this.currentPage,
  });

  @override
  List<Object?> get props => [pins, hasMore, currentPage];
}

class LikedPinsLoaded extends LikedPinsState {
  final List<Pin> pins;
  final bool hasMore;
  final int currentPage;
  final String? errorMessage;

  const LikedPinsLoaded({
    required this.pins,
    required this.hasMore,
    required this.currentPage,
    this.errorMessage,
  });
  @override
  List<Object> get props => [pins, hasMore, currentPage];
}

class LikedPinsError  extends LikedPinsState {
  final String message;
  const LikedPinsError ({required this.message});
  @override
  List<Object> get props => [message];
}