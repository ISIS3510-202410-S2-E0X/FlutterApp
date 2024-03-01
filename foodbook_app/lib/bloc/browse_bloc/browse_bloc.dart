import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/data/repository/restaurant_repo.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_event.dart';
import 'package:foodbook_app/bloc/browse_bloc/browse_state.dart';

class BrowseBloc extends Bloc<BrowseEvent, BrowseState> {
  final RestaurantRepository restaurantRepository;

  BrowseBloc({required this.restaurantRepository}) : super(RestaurantsInitial()) {
    on<LoadRestaurants>(_onLoadRestaurants);
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
}

