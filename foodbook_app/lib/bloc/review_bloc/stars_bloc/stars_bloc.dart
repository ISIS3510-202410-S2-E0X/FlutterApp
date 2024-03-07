import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/stars_bloc/stars_event.dart';
import 'package:foodbook_app/bloc/review_bloc/stars_bloc/stars_state.dart';

class StarsBloc extends Bloc<ReviewEvent, ReviewState> {
  StarsBloc() : super(ReviewInitial()) {
    on<ReviewRatingChanged>(_onReviewRatingChanged);
  }

  void _onReviewRatingChanged(
    ReviewRatingChanged event, Emitter<ReviewState> emit) {
      final currentState = state;
      Map<String, double> newRatings = {};

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
}
