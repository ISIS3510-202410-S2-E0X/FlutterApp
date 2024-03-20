import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/data/repositories/restaurant_repository.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_event.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_state.dart';
import 'package:foodbook_app/data/models/restaurant.dart';

class BrowseBloc extends Bloc<BrowseEvent, BrowseState> {
  final RestaurantRepository restaurantRepository;

  BrowseBloc({required this.restaurantRepository}) : super(RestaurantsInitial()) {
    on<LoadRestaurants>(_onLoadRestaurants);
    on<FilterRestaurants>(_onFilterRestaurants);
    //on<ToggleBookmark>(_onToggleBookmark);
  }

  void _onLoadRestaurants(LoadRestaurants event, Emitter<BrowseState> emit) async {
    emit(RestaurantsLoadInProgress());
    await Future.delayed(Duration(seconds: 1)); 
    try {
      final restaurants = restaurantRepository.fetchRestaurants();
      List<Restaurant> restaurantList = await restaurants;
      emit(RestaurantsLoadSuccess(restaurantList));
    } catch (error) {
      emit(RestaurantsLoadFailure(error.toString()));
    }
  }

  void _onFilterRestaurants(FilterRestaurants event, Emitter<BrowseState> emit) async {
    emit(RestaurantsLoadInProgress());
    try {
      final restaurants = await restaurantRepository.fetchRestaurants();
      final filteredRestaurants = _applyFilters(
        event.name,       // Nullable type
        event.price,       // Nullable type
        //event.distance,    // Nullable type
        event.category,    // Nullable type
        restaurants,
      );
      emit(RestaurantsLoadSuccess(filteredRestaurants));
    } catch (error) {
      emit(RestaurantsLoadFailure(error.toString()));
    }
  }

  List<Restaurant> _applyFilters(
    String? name,       // Nullable type
    String? price,       // Nullable type
    String? category,    // Nullable type
    List<Restaurant> restaurants,
  ) {
    // Add your filtering logic here, making sure to check for nulls
    // Example:
    return restaurants.where((restaurant) {
      final matchesName = name == null || restaurant.name.toLowerCase().contains(name.toLowerCase());
      final matchesPrice = price == null || restaurant.priceRange == price;
      //final withinDistance = distance == null || restaurant.distance <= distance;
      final matchesCategory = category == null || restaurant.categories.contains(category);
      return matchesName && matchesPrice && matchesCategory;
    }).toList();
  }


  // void _onToggleBookmark(ToggleBookmark event, Emitter<BrowseState> emit) async {
  //   emit(RestaurantsLoadInProgress()); // Show loading while processing the bookmark toggle
  //   try {
  //     await restaurantRepository.toggleBookmark(event.restaurantId);
  //     final restaurants = await restaurantRepository.fetchRestaurants(); // Re-fetch the updated list of restaurants
  //     emit(RestaurantsLoadSuccess(restaurants));
  //   } catch (error) {
  //     emit(RestaurantsLoadFailure(error.toString()));
  //   }
  // }

  
}

