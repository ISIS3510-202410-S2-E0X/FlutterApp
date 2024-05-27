import 'package:foodbook_app/data/models/restaurant.dart';

abstract class BrowseState {}

class RestaurantsInitial extends BrowseState {}

class RestaurantsLoadInProgress extends BrowseState {
  List<Object> get props => [];
}

class RestaurantsLoadSuccess extends BrowseState {
  final List<Restaurant> restaurants;

  RestaurantsLoadSuccess(this.restaurants);

  List<Object> get props => [restaurants];
}

class RestaurantsRecommendationLoadSuccess extends BrowseState {
  final List<Restaurant> recommendedRestaurants;

  RestaurantsRecommendationLoadSuccess(this.recommendedRestaurants);

  List<Object> get props => [recommendedRestaurants];
}

class RestaurantsLoadFailure extends BrowseState {
  final String error;

  RestaurantsLoadFailure(this.error);
}

class SearchLoading2 extends BrowseState {}

class SearchSuccess2 extends BrowseState {
  late final List<dynamic> results;

  @override
  List<Object> get props => [results];

  @override
  String toString() => 'SearchSuccess { results: $results }';
}

class SearchFailure2 extends BrowseState {
  final String error;

  SearchFailure2(this.error);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'SearchFailure { error: $error }';
}

class SearchFinalized extends BrowseState {
}
class SearchSuccess extends BrowseState {
  late final List<dynamic> results;

  @override
  List<Object> get props => [results];

  @override
  String toString() => 'SearchSuccess { results: $results }';
}

class Prefilter extends BrowseState {
}
class SearchBlocked extends BrowseState {
}