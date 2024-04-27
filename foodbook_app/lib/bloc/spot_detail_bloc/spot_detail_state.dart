import 'package:foodbook_app/data/models/restaurant.dart';

abstract class SpotDetailState {}

class SpotDetailInitial extends SpotDetailState {}

class SpotDetailLoadInProgress extends SpotDetailState {}

class SpotDetailLoadSuccess extends SpotDetailState {
  final Restaurant restaurant;
  SpotDetailLoadSuccess(this.restaurant);
}

class SpotDetailLoadFailure extends SpotDetailState {
  final String restaurantId;
  SpotDetailLoadFailure(this.restaurantId);
}

