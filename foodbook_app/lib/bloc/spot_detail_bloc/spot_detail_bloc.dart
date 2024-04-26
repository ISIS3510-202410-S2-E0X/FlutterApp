// spot_detail_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/spot_detail_bloc/spot_detail_event.dart';
import 'package:foodbook_app/bloc/spot_detail_bloc/spot_detail_state.dart';
import 'package:foodbook_app/data/models/restaurant.dart';
import 'package:foodbook_app/data/repositories/restaurant_repository.dart';


class SpotDetailBloc extends Bloc<SpotDetailEvent, SpotDetailState> {
  final RestaurantRepository restaurantRepository;

  SpotDetailBloc(this.restaurantRepository) : super(SpotDetailInitial()) {
    on<FetchRestaurantDetail>(_onFetchRestaurantDetail);
  }

  Future<void> _onFetchRestaurantDetail(
    FetchRestaurantDetail event,
    Emitter<SpotDetailState> emit,
  ) async {
    emit(SpotDetailLoadInProgress());
    try {
      final Restaurant? restaurant = await restaurantRepository.fetchRestaurantById(event.restaurantId);
      if (restaurant != null) {
        emit(SpotDetailLoadSuccess(restaurant));
      } else {
        emit(SpotDetailLoadFailure('Restaurant not found.'));
      }
    } catch (e) {
      emit(SpotDetailLoadFailure(e.toString()));
    }
  }
}
