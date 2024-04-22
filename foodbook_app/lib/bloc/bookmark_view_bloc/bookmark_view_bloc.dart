import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_view_bloc/bookmark_view_event.dart';
import 'package:foodbook_app/bloc/bookmark_view_bloc/bookmark_view_state.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:foodbook_app/data/repositories/bookmark_manager.dart';

class BookmarkViewBloc extends Bloc<BookmarkViewEvent, BookmarkViewState> {
  final BookmarkManager bookmarkManager;

  BookmarkViewBloc(this.bookmarkManager) : super(BookmarkViewInitial()) {
    on<LoadBookmarkedRestaurants>(_onLoadBookmarkedRestaurants);
  }

  Future<void> _onLoadBookmarkedRestaurants(
    LoadBookmarkedRestaurants event,
    Emitter<BookmarkViewState> emit,
  ) async {
    emit(BookmarksLoadInProgress());
    try {
      final bookmarks = await bookmarkManager.getBookmarkedRestaurants();
      final List<Restaurant> bookmarkedRestaurants = [];
      for (var name in bookmarks) {
        final details = await bookmarkManager.getRestaurantDetails(name);
        if (details != null) {
          bookmarkedRestaurants.add(details);
        }
      }
      emit(BookmarkedRestaurantsLoaded(bookmarkedRestaurants));
    } catch (error) {
      emit(BookmarksLoadFailure(error.toString()));
    }
  }
}
