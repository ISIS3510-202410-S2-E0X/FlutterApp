import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_bloc/bookmark_event.dart';
import 'package:foodbook_app/bloc/bookmark_bloc/bookmark_state.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:foodbook_app/data/repositories/bookmark_manager.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  final BookmarkManager bookmarkManager;

  BookmarkBloc(this.bookmarkManager) : super(BookmarkInitial()) {
    on<CheckBookmark>((event, emit) async {
      bool isBookmarked = await bookmarkManager.isBookmarked(event.restaurantName);
      emit(BookmarkLoaded(isBookmarked));
    });

    on<ToggleBookmark>((event, emit) async {
      bool isBookmarked = await bookmarkManager.isBookmarked(event.restaurant.name);
      if (isBookmarked) {
        await bookmarkManager.unbookmarkRestaurant(event.restaurant.name);
      } else {
        await bookmarkManager.bookmarkRestaurant(event.restaurant);
      }
      emit(BookmarkLoaded(!isBookmarked));
    });

    on<LoadBookmarkedRestaurants>((event, emit) async {
      try {
        final bookmarks = await bookmarkManager.getBookmarkedRestaurants();
        final List<Restaurant> bookmarkedRestaurants = [];
        for (var name in bookmarks) {
          final details = await bookmarkManager.getRestaurantDetails(name);
          if (details != null) {
            bookmarkedRestaurants.add(details);
          }
        }
        emit(BookmarkedRestaurantsLoaded(bookmarkedRestaurants)); // You will need to create this state
      } catch (error) {
        emit(BookmarksLoadFailure(error.toString())); // You will need to create this state
      }
    });


  }
}
