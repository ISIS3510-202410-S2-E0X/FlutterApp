// Define los posibles estados en los que se puede encontrar el BLoC
abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewRatings extends ReviewState {
  final Map<String, double> ratings;

  ReviewRatings(this.ratings);
}