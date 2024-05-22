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
    Stopwatch stopwatch = Stopwatch()..start();
    emit(SpotDetailLoadInProgress());
    try {
      final Restaurant? restaurant = await restaurantRepository.fetchRestaurantById(event.restaurantId);
      stopwatch.stop();
      if (restaurant != null) {
        print('Fetched restaurant in ${stopwatch.elapsedMilliseconds}ms');
        restaurantRepository.addSpotDetailFetchingTime(event.restaurantId, double.parse((stopwatch.elapsedMilliseconds / 1000.0).toStringAsFixed(2)));
        emit(SpotDetailLoadSuccess(restaurant));
      } else {
        emit(SpotDetailLoadFailure(event.restaurantId));
      }
    } catch (e) {
      emit(SpotDetailLoadFailure(event.restaurantId));
    }
  }
}
