abstract class BookmarkEvent {}

class CheckBookmark extends BookmarkEvent {
  final String restaurantName;
  CheckBookmark(this.restaurantName);
}

class ToggleBookmark extends BookmarkEvent {
  final String restaurantName;
  ToggleBookmark(this.restaurantName);
}
