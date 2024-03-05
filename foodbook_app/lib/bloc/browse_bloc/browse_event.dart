abstract class BrowseEvent {}

class LoadRestaurants extends BrowseEvent {}

// browse_event.dart
class FilterRestaurants extends BrowseEvent {
  final String? price;       // Nullable type
  final double? distance;    // Nullable type
  final String? category;    // Nullable type

  FilterRestaurants({
    this.price,       // Nullable type
    this.distance,    // Nullable type
    this.category,    // Nullable type
  });
}

class ToggleBookmark extends BrowseEvent {
  final String restaurantId;

  ToggleBookmark(this.restaurantId);
}
