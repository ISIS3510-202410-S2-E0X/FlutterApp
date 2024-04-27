abstract class SpotDetailEvent {}

class FetchRestaurantDetail extends SpotDetailEvent {
  final String restaurantId;
  FetchRestaurantDetail(this.restaurantId);
}

