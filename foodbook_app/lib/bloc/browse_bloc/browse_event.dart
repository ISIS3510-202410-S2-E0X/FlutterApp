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
class SearchWord2 extends BrowseEvent {
  final String query;


  SearchWord2({required this.query});

  @override
  List<Object> get props => [query];
}

class AddSuggestion2 extends BrowseEvent {
  final String query;

  AddSuggestion2({required this.query});

  @override
  List<Object> get props => [query];
}

class RemoveSuggestion2 extends BrowseEvent {}

class SearchButtonPressed2 extends BrowseEvent {
  final String query;

  SearchButtonPressed2({required this.query});

}
class SelectSuggested2 extends BrowseEvent {
  final String suggestion;
  SelectSuggested2({required this.suggestion});
  @override
  List<Object> get props => [suggestion];
}

class TooLongSearch extends BrowseEvent {
  final String query;

  TooLongSearch({required this.query});

  @override
  List<Object> get props => [query];
}

// class ToggleBookmark extends BrowseEvent {
//   final String restaurantId;

//   ToggleBookmark(this.restaurantId);
// }

