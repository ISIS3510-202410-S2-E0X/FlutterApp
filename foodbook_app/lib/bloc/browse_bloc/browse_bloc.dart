import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/search_bloc/search_state.dart';
import 'package:foodbook_app/data/repositories/restaurant_repository.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_event.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_state.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:foodbook_app/data/repositories/review_repository.dart';
import 'package:foodbook_app/data/repositories/shared_preferences_repository.dart';

class BrowseBloc extends Bloc<BrowseEvent, BrowseState> {
  final RestaurantRepository restaurantRepository;
  final ReviewRepository reviewRepository;
  final SharedPreferencesRepository repository = SharedPreferencesRepository();

  BrowseBloc({required this.restaurantRepository, required this.reviewRepository}) : super(RestaurantsInitial()) {
    on<LoadRestaurants>(_onLoadRestaurants);
    on<FilterRestaurants>(_onFilterRestaurants);
    on<FetchRecommendedRestaurants>(_onFetchRecommendedRestaurants);
    on<SearchWord2>(_onSearchWord);
    on<SearchButtonPressed2>(_onSearchButtonPressed);
    on<AddSuggestion2>(_onAddSuggestion);
    //on<ToggleBookmark>(_onToggleBookmark);
  }

  void _onLoadRestaurants(LoadRestaurants event, Emitter<BrowseState> emit) async {
    emit(RestaurantsLoadInProgress());
    
    try {
      final restaurants = await restaurantRepository.fetchRestaurants();
      print("Restaurants size: ${restaurants.length}");
      if (restaurants.isEmpty) {
        final cachedRests = await restaurantRepository.fetchRestaurantsFromCache();
        if (cachedRests.isEmpty) {
          emit(RestaurantsLoadFailure('No restaurants found'));
        }
        
        emit(RestaurantsLoadSuccess(cachedRests));
        print("Fetched restaurants from cache");
      }
      if (restaurants.isNotEmpty) {
        emit(RestaurantsLoadSuccess(restaurants));
      }
      
    } catch (error) {
      emit(RestaurantsLoadFailure(error.toString()));
    }
  }

  void _onFilterRestaurants(FilterRestaurants event, Emitter<BrowseState> emit) async {
    emit(RestaurantsLoadInProgress());
    await repository.saveSearchTerm(event.name!);
    print("Saving the query to search history: ${event.name}");
    try {
      final restaurants = await restaurantRepository.fetchRestaurants();
      final filteredRestaurants = _applyFilters(
        event.name,
        event.price,
        event.category,
        restaurants,
      );
      if (filteredRestaurants.isEmpty) {
        emit(RestaurantsLoadFailure('No restaurants found'));
        return;
      }
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
  void _onSearchWord(SearchWord2 event, Emitter<BrowseState> emit) async {
      try {
        emit(SearchLoading2());
      } catch (e) {
        emit(SearchFailure2(e.toString()));
      }
  }
  void _onSearchButtonPressed(SearchButtonPressed2 event, Emitter<BrowseState> emit) async {
    emit(SearchLoading2());
  }
  void _onAddSuggestion(AddSuggestion2 event, Emitter<BrowseState> emit) async {
    emit(SearchFinalized());
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
