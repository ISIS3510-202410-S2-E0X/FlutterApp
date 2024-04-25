import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/stars_bloc/stars_event.dart';
import 'package:foodbook_app/bloc/review_bloc/stars_bloc/stars_state.dart';

class StarsBloc extends Bloc<ReviewEvent, ReviewState> {
  Map<String, double> newRatings = {};

  StarsBloc() : super(ReviewInitial()) {
    on<ReviewRatingChanged>(_onReviewRatingChanged);
    on<InitializeRatings>(_onInitializeRatings);
  }

  void _onReviewRatingChanged(
    ReviewRatingChanged event, Emitter<ReviewState> emit) {
      final currentState = state;

      // if the current state already has ratings, we copy them to the new map
      if (currentState is ReviewRatings) {
        newRatings = Map<String, double>.from(currentState.ratings);
      }

      // We update the rating for the specific category
      newRatings[event.category] = event.rating;

      // Print the current ratings map before updating
      print('Current Ratings: ${currentState is ReviewRatings ? currentState.ratings : 'No ratings yet'}');

      // Print the new ratings map
      print('New Ratings: $newRatings');

      // We emit a new state with the updated ratings
      emit(ReviewRatings(newRatings));
  }

  void _onInitializeRatings(InitializeRatings event, Emitter<ReviewState> emit) {
    newRatings = Map.from(event.initialRatings);
    print('Initial Ratings: $newRatings');
    for (var key in newRatings.keys) {
      add(ReviewRatingChanged(key, newRatings[key]!));
    }
    emit(ReviewRatings(newRatings));
  }
}