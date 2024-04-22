import 'package:foodbook_app/data/models/restaurant.dart';

abstract class BookmarkState {}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoaded extends BookmarkState {
  final bool isBookmarked;
  BookmarkLoaded(this.isBookmarked);
}

class BookmarkedRestaurantsLoaded extends BookmarkState {
  final List<Restaurant> bookmarkedRestaurants;
  BookmarkedRestaurantsLoaded(this.bookmarkedRestaurants);
}

class BookmarksLoadFailure extends BookmarkState {
  final String error;
  BookmarksLoadFailure(this.error);
}