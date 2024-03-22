abstract class BrowseEvent {}

class LoadRestaurants extends BrowseEvent {
  LoadRestaurants();
}

class FetchRecommendedRestaurants extends BrowseEvent {
  final String username;

  FetchRecommendedRestaurants(this.username);
}

class FilterRestaurants extends BrowseEvent {
  final String? name;       // Nullable type
  final String? price;       // Nullable type
  final double? distance;    // Nullable type
  final String? category;    // Nullable type

  FilterRestaurants({
    this.name,       // Nullable type
    this.price,       // Nullable type
    this.distance,    // Nullable type
    this.category,    // Nullable type
  });
}

// class ToggleBookmark extends BrowseEvent {
//   final String restaurantId;

//   ToggleBookmark(this.restaurantId);
// }

