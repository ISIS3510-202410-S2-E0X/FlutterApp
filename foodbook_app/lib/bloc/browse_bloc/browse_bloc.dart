import 'package:flutter_bloc/flutter_bloc.dart';
import 'browse_event.dart';
import 'browse_state.dart';

class BrowseBloc extends Bloc<BrowseEvent, BrowseState> {
  BrowseBloc() : super(BrowseInitial()) {
    on<LoadRestaurantsEvent>((event, emit) async {
      // Here you'd fetch data from a repository or API
      emit(BrowseLoadInProgress());
      try {
        // Simulated delay for fetching data
        await Future.delayed(Duration(seconds: 2));
        // Emitting a state with dummy data
        emit(BrowseLoadSuccess([
          // Add Restaurant objects with the necessary data
        ]));
      } catch (_) {
        emit(BrowseLoadFailure());
      }
    });
  }
}
