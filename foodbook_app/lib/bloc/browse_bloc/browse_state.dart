import 'package:foodbook_app/data/models/restaurant.dart';

abstract class BrowseState {}

class RestaurantsInitial extends BrowseState {}

class RestaurantsLoadInProgress extends BrowseState {
  @override
  List<Object> get props => [];
}

class RestaurantsLoadSuccess extends BrowseState {
  final List<Restaurant> restaurants;

  RestaurantsLoadSuccess(this.restaurants);

  @override
  List<Object> get props => [restaurants];
}

class RestaurantsLoadFailure extends BrowseState {
  final String error;

  RestaurantsLoadFailure(this.error);
}

