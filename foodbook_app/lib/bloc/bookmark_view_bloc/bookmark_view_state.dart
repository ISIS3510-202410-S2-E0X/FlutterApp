
import 'package:foodbook_app/data/models/restaurant.dart';

abstract class BookmarkViewState{}

class BookmarkViewInitial extends BookmarkViewState {}

class BookmarkedRestaurantsLoaded extends BookmarkViewState {
  final List<Restaurant> bookmarkedRestaurants;
  BookmarkedRestaurantsLoaded(this.bookmarkedRestaurants);
}

class BookmarksLoadInProgress extends BookmarkViewState {} 

class BookmarksLoadFailure extends BookmarkViewState {
  final String error;
  BookmarksLoadFailure(this.error);
}
