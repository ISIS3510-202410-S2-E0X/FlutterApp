import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/data/repository/restaurant_repo.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_event.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_state.dart';
import 'package:foodbook_app/data/models/restaurant.dart';

class BrowseBloc extends Bloc<BrowseEvent, BrowseState> {
  final RestaurantRepository restaurantRepository;

  BrowseBloc({required this.restaurantRepository}) : super(RestaurantsInitial()) {
    on<LoadRestaurants>(_onLoadRestaurants);
    on<FilterRestaurants>(_onFilterRestaurants); // Add this line
  }

  void _onLoadRestaurants(LoadRestaurants event, Emitter<BrowseState> emit) async {
    emit(RestaurantsLoadInProgress());
    try {
      final restaurants = restaurantRepository.fetchRestaurants();
      emit(RestaurantsLoadSuccess(restaurants));
    } catch (error) {
      emit(RestaurantsLoadFailure(error.toString()));
    }
  }

  void _onFilterRestaurants(FilterRestaurants event, Emitter<BrowseState> emit) async {
    emit(RestaurantsLoadInProgress());
    try {
      final restaurants = await restaurantRepository.fetchRestaurants();
      final filteredRestaurants = _applyFilters(
        event.price,       // Nullable type
        event.distance,    // Nullable type
        event.category,    // Nullable type
        restaurants,
      );
      emit(RestaurantsLoadSuccess(filteredRestaurants));
    } catch (error) {
      emit(RestaurantsLoadFailure(error.toString()));
    }
  }

  List<Restaurant> _applyFilters(
    String? price,       // Nullable type
    double? distance,    // Nullable type
    String? category,    // Nullable type
    List<Restaurant> restaurants,
  ) {
    // Add your filtering logic here, making sure to check for nulls
    // Example:
    return restaurants.where((restaurant) {
      final matchesPrice = price == null || restaurant.priceRange == price;
      final withinDistance = distance == null || restaurant.distance <= distance;
      final matchesCategory = category == null || restaurant.categories.contains(category);
      return matchesPrice && withinDistance && matchesCategory;
    }).toList();
  }

  
}

