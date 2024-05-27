import 'package:foodbook_app/data/dtos/review_dto.dart';
import 'package:foodbook_app/data/models/review.dart';

abstract class ReviewEvent {}

class CreateReviewEvent extends ReviewEvent {
  final ReviewDTO reviewDTO;
  final String restaurantName;

  CreateReviewEvent(this.reviewDTO, this.restaurantName);

  List<Object> get props => [reviewDTO, restaurantName];
}

class FetchUserReviews extends ReviewEvent {
  final String userId;
  final String userName;

  FetchUserReviews(this.userId, this.userName);

  List<Object> get props => [userId];
}
