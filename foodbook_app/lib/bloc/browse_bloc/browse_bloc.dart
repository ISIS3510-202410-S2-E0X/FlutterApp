import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/data/repositories/restaurant_repository.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_event.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_state.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:foodbook_app/data/repositories/review_repository.dart';

class BrowseBloc extends Bloc<BrowseEvent, BrowseState> {
  final RestaurantRepository restaurantRepository;
  final ReviewRepository reviewRepository;

  BrowseBloc({required this.restaurantRepository, required this.reviewRepository}) : super(RestaurantsInitial()) {
    on<LoadRestaurants>(_onLoadRestaurants);
    on<FilterRestaurants>(_onFilterRestaurants);
    on<FetchRecommendedRestaurants>(_onFetchRecommendedRestaurants);
    //on<ToggleBookmark>(_onToggleBookmark);
  }

  void _onLoadRestaurants(LoadRestaurants event, Emitter<BrowseState> emit) async {
    emit(RestaurantsLoadInProgress());
    await Future.delayed(const Duration(seconds: 1));
    try {
      final restaurants = await restaurantRepository.fetchRestaurants();
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
        event.name,
        event.price,
        event.category,
        restaurants,
      );
      emit(RestaurantsLoadSuccess(filteredRestaurants));
    } catch (error) {
      emit(RestaurantsLoadFailure(error.toString()));
    }
  }

  void _onFetchRecommendedRestaurants(FetchRecommendedRestaurants event, Emitter<BrowseState> emit) async {
    emit(RestaurantsLoadInProgress());
    try {
      var ids = [];
      if (ids.isEmpty) {
        while (ids.isEmpty) {
          ids = await restaurantRepository.getRestaurantsIdsFromIntAPI(event.username);
        }
      }
      List<Restaurant> recommendedRestaurants = [];
      for (var id in ids) {
        var restaurant = await restaurantRepository.fetchRestaurantById(id);
        if (restaurant != null) {
          recommendedRestaurants.add(restaurant);
        }
      }
      
      emit(RestaurantsRecommendationLoadSuccess(recommendedRestaurants));
    } catch (error) {
      emit(RestaurantsLoadFailure(error.toString()));
    }
  }

  List<Restaurant> _applyFilters(
    String? name,
    String? price,
    String? category,
    List<Restaurant> restaurants,
  ) {
    return restaurants.where((restaurant) {
      final matchesName = name == null || restaurant.name.toLowerCase().contains(name.toLowerCase());
      final matchesPrice = price == null || restaurant.priceRange == price;
      final matchesCategory = category == null || restaurant.categories.contains(category);
      return matchesName && matchesPrice && matchesCategory;
    }).toList();
  }
}
