  import 'package:flutter_bloc/flutter_bloc.dart';
  import 'package:social_platform_example/features/feed/domain/entities/pins_page.dart';  import 'package:social_platform_example/features/profile/domain/usecases/get_likes_use_case.dart';
  import 'package:social_platform_example/features/feed/domain/entities/pin.dart';
  import 'liked_pins_state.dart';

  class LikedPinsCubit extends Cubit<LikedPinsState>{

    List<Pin> _loadedPins = [];
    int _currentPage = 0;
    bool _hasMore = false;
    bool _isLoading = false;

    final int firstPageLimit;
    final int nextPageLimit;
    final GetLikesUseCase getLikesUseCase;

    LikedPinsCubit({
      required this.getLikesUseCase,
      required this.firstPageLimit,
      required this.nextPageLimit,
    }) : super(LikedPinsInitial());

    Future<PinsPage> _getLikesPage(int limit) async{
      final likesPage = await getLikesUseCase(
        page: _currentPage + 1,
        limit: limit,
      );
      return likesPage;
    }

    void _update(PinsPage likesPage){
      _loadedPins.addAll(likesPage.pins);
      _hasMore = likesPage.hasMore;
      _currentPage = likesPage.page;
    }

    Future<void> loadFirstPage() async{
      if (_isLoading) return;
      _isLoading = true;
      emit(const LikedPinsLoading());
      try {
        _loadedPins = [];
        _currentPage = 0;
        final likesPage = await _getLikesPage(firstPageLimit);
        _update(likesPage);
        emit(LikedPinsLoaded(
          pins: _loadedPins,
          hasMore: _hasMore,
          currentPage: _currentPage,
        ));
      } catch (e) {
        emit(LikedPinsError(message: e.toString()));
      }
      _isLoading = false;
    }

    Future<void> loadNextPage() async {
      if (!_isLoading && _hasMore) {
        _isLoading = true;
        emit(LikedPinsLoading(
          pins: _loadedPins,
          hasMore: _hasMore,
          currentPage: _currentPage,
        ));
        try {
          final likesPage = await _getLikesPage(nextPageLimit);
          _update(likesPage);
          emit(LikedPinsLoaded(
            pins: _loadedPins,
            hasMore: _hasMore,
            currentPage: _currentPage,
          ));
        } catch (e) {
          emit(LikedPinsLoaded(
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
