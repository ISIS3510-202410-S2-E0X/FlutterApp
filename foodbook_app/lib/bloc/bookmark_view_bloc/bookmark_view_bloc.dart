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
    List<String> failedToLoad = [];
    try {
      final bookmarks = await bookmarkManager.getBookmarkedRestaurants();
      //Simulate there is another restaurant in bookmarks that is not in cache
      //bookmarks.add("El Corral");
      final List<Restaurant> bookmarkedRestaurants = [];
      for (var name in bookmarks) {
        var details = await bookmarkManager.getRestaurantDetails(name);
        if (details == null) {
          details = await restaurantRepository.findRestaurantByName(name); // Use RestaurantRepository here
        }
        if (details != null) {
          bookmarkedRestaurants.add(details);
        } else {
          failedToLoad.add(name);
        }
      }

      if (failedToLoad.isNotEmpty) {
        emit(BookmarksLoadFailure("The bookmarked restaurants: ${failedToLoad.join(', ')} are not in cache and couldn't be accessed through network. Try again with an internet connection."));
      } else {
        emit(BookmarkedRestaurantsLoaded(bookmarkedRestaurants));
      }
    } catch (error) {
      emit(BookmarksLoadFailure(error.toString()));
    }
  }
}
