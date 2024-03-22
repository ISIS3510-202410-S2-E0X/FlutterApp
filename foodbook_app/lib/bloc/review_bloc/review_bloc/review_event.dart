import 'package:foodbook_app/data/dtos/review_dto.dart';

abstract class ReviewEvent {}

class CreateReviewEvent extends ReviewEvent {
  final ReviewDTO reviewDTO;
  final String restaurantName;

  CreateReviewEvent(this.reviewDTO, this.restaurantName);

  List<Object> get props => [reviewDTO, restaurantName];
}
