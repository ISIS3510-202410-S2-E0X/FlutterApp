import 'package:foodbook_app/data/dtos/review_dto.dart';

abstract class ReviewEvent {}

class CreateReviewEvent extends ReviewEvent {
  final ReviewDTO reviewDTO;

  CreateReviewEvent({required this.reviewDTO});  
}
