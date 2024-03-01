import 'package:foodbook_app/data/models/restaurant.dart';

abstract class BrowseState {}

class RestaurantsInitial extends BrowseState {}

class RestaurantsLoadInProgress extends BrowseState {}

class RestaurantsLoadSuccess extends BrowseState {
  final List<Restaurant> restaurants;

  RestaurantsLoadSuccess(this.restaurants);
}

class RestaurantsLoadFailure extends BrowseState {
  final String error;

  RestaurantsLoadFailure(this.error);
}

