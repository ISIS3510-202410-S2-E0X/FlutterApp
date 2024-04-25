import 'package:foodbook_app/data/models/restaurant.dart';

abstract class BookmarkEvent {}

class CheckBookmark extends BookmarkEvent {
  final String restaurantId;
  CheckBookmark(this.restaurantId);
}

class ToggleBookmark extends BookmarkEvent {
  final Restaurant restaurant;
  ToggleBookmark(this.restaurant);
}