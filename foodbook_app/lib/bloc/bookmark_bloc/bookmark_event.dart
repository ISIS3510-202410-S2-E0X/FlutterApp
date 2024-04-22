import 'package:foodbook_app/data/models/restaurant.dart';

abstract class BookmarkEvent {}

class CheckBookmark extends BookmarkEvent {
  final String restaurantName;
  CheckBookmark(this.restaurantName);
}

class ToggleBookmark extends BookmarkEvent {
  final Restaurant restaurant;
  ToggleBookmark(this.restaurant);
}

class LoadBookmarkedRestaurants extends BookmarkEvent {}