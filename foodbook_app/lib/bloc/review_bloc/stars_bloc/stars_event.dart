// Define los eventos que el BLoC puede recibir
abstract class ReviewEvent {}

class ReviewRatingChanged extends ReviewEvent {
  final String category;
  final double rating;

  ReviewRatingChanged(this.category, this.rating);
}

class InitializeRatings extends ReviewEvent {
  final Map<String, double> initialRatings;
  InitializeRatings(this.initialRatings);
}
