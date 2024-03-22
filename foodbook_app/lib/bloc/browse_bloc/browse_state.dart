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

