import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/review_bloc/review_event.dart';
import 'package:foodbook_app/bloc/review_bloc/review_bloc/review_state.dart';
import 'package:foodbook_app/data/repositories/restaurant_repository.dart';
import 'package:foodbook_app/data/repositories/review_repository.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository reviewRepository;
  final RestaurantRepository restaurantRepository;

  ReviewBloc({required this.reviewRepository, required this.restaurantRepository})
      : super(InitialState()) {
    on<CreateReviewEvent>(_onCreateReviewEvent);
    on<FetchUserReviews>(_onGetUserReviews);
  }

  Future<void> _onCreateReviewEvent(CreateReviewEvent event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    try {
      final reviewId = await reviewRepository.create(review: event.reviewDTO);
      final restaurantId = await restaurantRepository.findRestaurantIdByName(event.restaurantName);
      if (restaurantId != null) {
        await restaurantRepository.addReviewToRestaurant(restaurantId, reviewId);
        emit(ReviewCreateSuccess(reviewId)); // Estado de éxito con el ID de la revisión.
      } else {
        emit(ReviewError("Error: Restaurant not found."));
      }
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
  Future<void> _onGetUserReviews(FetchUserReviews event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    try {
      final cachedUserReviews = await reviewRepository.fetchUserReviewsFromCache(event.userId);
      if (cachedUserReviews.isNotEmpty) {
        emit(ReviewFetchUserReviewsSuccess(cachedUserReviews));
      }
      if (cachedUserReviews.isEmpty) {
        final userReviews = await reviewRepository.fetchUserReviews(event.userId, event.userName);
        emit(ReviewFetchUserReviewsSuccess(userReviews));
      }
      else {
        emit(ReviewError("Please connect to the internet."));
      }
      
    } catch (e) {
      print("Error JSON: $e");
      emit(ReviewError(e.toString()));
    }
  }


}
