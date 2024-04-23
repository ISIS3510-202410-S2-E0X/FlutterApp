
import 'package:foodbook_app/data/models/restaurant.dart';

abstract class BookmarkViewState{}

class BookmarkViewInitial extends BookmarkViewState {}

class BookmarkedRestaurantsLoaded extends BookmarkViewState {
  final List<Restaurant> bookmarkedRestaurants;
  BookmarkedRestaurantsLoaded(this.bookmarkedRestaurants);
}

class BookmarksLoadInProgress extends BookmarkViewState {} 

class BookmarksLoadFailure extends BookmarkViewState {
  final List<Restaurant> successfullyLoaded;
  final List<String> failedToLoadNames;
  final String errorMessage;

  BookmarksLoadFailure({
    required this.successfullyLoaded,
    required this.failedToLoadNames,
    required this.errorMessage,
  });
}
