import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_view_bloc/bookmark_view_event.dart';
import 'package:foodbook_app/bloc/bookmark_view_bloc/bookmark_view_state.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:foodbook_app/data/repositories/bookmark_manager.dart';
import 'package:foodbook_app/data/repositories/restaurant_repository.dart'; // Import your RestaurantRepository

class BookmarkViewBloc extends Bloc<BookmarkViewEvent, BookmarkViewState> {
  final BookmarkManager bookmarkManager;
  final RestaurantRepository restaurantRepository; // Add RestaurantRepository

  BookmarkViewBloc({
    required this.bookmarkManager,
    required this.restaurantRepository,
  }) : super(BookmarkViewInitial()) {
    on<LoadBookmarkedRestaurants>(_onLoadBookmarkedRestaurants);
  }

  Future<void> _onLoadBookmarkedRestaurants(
    LoadBookmarkedRestaurants event,
    Emitter<BookmarkViewState> emit,
  ) async {
    emit(BookmarksLoadInProgress());

    final List<Restaurant> bookmarkedRestaurants = [];
    final List<String> failedToLoad = [];

    try {
      final bookmarks = await bookmarkManager.getBookmarkedRestaurants();
      // Simulate there is a restaurant not in bookmarks
      //bookmarks.add("Hornitos2");

      for (var id in bookmarks) {
        var details = await bookmarkManager.getRestaurantDetails(id);
        if (details == null) {
          details = await restaurantRepository.fetchRestaurantById(id); // Use RestaurantRepository
        }
        if (details != null) {
          bookmarkedRestaurants.add(details);
        } else {
          failedToLoad.add(id);
        }
      }

			if (bookmarks.isEmpty || bookmarkedRestaurants.isEmpty) {
        emit(BookmarkLoadCompletelyFailed(
          errorMessage: "Failed to load any bookmarked restaurants.",
        ));
      } else if (failedToLoad.isNotEmpty) {
        emit(BookmarksLoadFailure(
          successfullyLoaded: bookmarkedRestaurants,
          failedToLoadNames: failedToLoad,
          errorMessage: "Some restaurants couldn't be loaded.",
        ));
      } else {
        emit(BookmarkedRestaurantsLoaded(bookmarkedRestaurants));
      }
    } catch (error) {
      emit(BookmarksLoadFailure(
        successfullyLoaded: bookmarkedRestaurants,
        failedToLoadNames: failedToLoad,
        errorMessage: error.toString(),
      ));
    }
  }
}
