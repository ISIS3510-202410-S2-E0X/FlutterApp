abstract class BrowseState {}

class BrowseInitial extends BrowseState {}

class BrowseLoadInProgress extends BrowseState {}

class BrowseLoadSuccess extends BrowseState {
  final List<Restaurant> restaurants;

  BrowseLoadSuccess(this.restaurants);
}

class BrowseLoadFailure extends BrowseState {}

// You'll need to define a Restaurant model that matches the data you're displaying
class Restaurant {
  final String name;
  final String priceIndicator;
  final String waitTime;
  final String distance;
  final List<String> tags;
  final List<String> imageUrls;

  Restaurant({
    required this.name,
    required this.priceIndicator,
    required this.waitTime,
    required this.distance,
    required this.tags,
    required this.imageUrls,
  });
}
