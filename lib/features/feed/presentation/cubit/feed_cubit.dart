import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_platform_example/features/feed/domain/entities/pins_page.dart';
import 'package:social_platform_example/features/feed/domain/usecases/get_pins_use_case.dart';
import 'package:social_platform_example/features/feed/domain/entities/pin.dart';
import 'feed_state.dart';

class FeedCubit extends Cubit<FeedState>{

  List<Pin> _loadedPins = [];
  int _currentPage = 0;
  bool _hasMore = false;
  bool _isLoading = false;

  final int firstPageLimit;
  final int nextPageLimit;
  final GetPinsUseCase getPinsUseCase;

  FeedCubit({
    required this.getPinsUseCase,
    required this.firstPageLimit,
    required this.nextPageLimit,
  }) : super(FeedInitial());

  Future<PinsPage> _getPinsPage(int limit) async{
    final pinsPage = await getPinsUseCase(
      page: _currentPage + 1,
      limit: limit,
    );
    return pinsPage;
  }

  void _update(PinsPage pinsPage){
    _loadedPins.addAll(pinsPage.pins);
    _hasMore = pinsPage.hasMore;
    _currentPage = pinsPage.page;
  }

  Future<void> loadFirstPage() async{
    if (_isLoading) return;
    _isLoading = true;
    emit(const FeedLoading());
    try {
      _loadedPins = [];
      _currentPage = 0;
      final pinsPage = await _getPinsPage(firstPageLimit);
      _update(pinsPage);
      emit(FeedLoaded(
        pins: _loadedPins,
        hasMore: _hasMore,
        currentPage: _currentPage,
      ));
    } catch (e) {
      emit(FeedError(message: e.toString()));
    }
    _isLoading = false;
  }

  Future<void> loadNextPage() async {
    if (!_isLoading && _hasMore) {
      _isLoading = true;
      emit(FeedLoading(
        pins: _loadedPins,
        hasMore: _hasMore,
        currentPage: _currentPage,
      ));
      try {
        final pinsPage = await _getPinsPage(nextPageLimit);
        _update(pinsPage);
        emit(FeedLoaded(
          pins: _loadedPins,
          hasMore: _hasMore,
          currentPage: _currentPage,
        ));
      } catch (e) {
        emit(FeedLoaded(
          pins: _loadedPins,
          hasMore: _hasMore,
          currentPage: _currentPage,
          errorMessage: e.toString(),
        ));
      } finally {
        _isLoading = false;
      }
    }
  }


}
