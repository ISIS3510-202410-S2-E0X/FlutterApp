import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/review_bloc/review_bloc/review_event.dart';
import 'package:foodbook_app/bloc/review_bloc/review_bloc/review_state.dart';
import 'package:foodbook_app/data/repositories/review_repository.dart';



class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository reviewRepository;
  ReviewBloc({ required this.reviewRepository }) : super(InitialState()) {
    on<CreateReviewEvent>((event, emit) async {
      emit(ReviewAdding());
      await Future.delayed(const Duration(seconds: 1));
      try {
        await reviewRepository.create(review: event.reviewDTO);
        emit(ReviewAdded());
      } catch (e) {
        emit(ReviewError(e.toString()));
      }
    });
  }
}