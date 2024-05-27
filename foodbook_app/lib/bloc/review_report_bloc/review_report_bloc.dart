import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/review_report_bloc/review_report_event.dart';
import 'package:foodbook_app/bloc/review_report_bloc/review_report_state.dart';
import 'package:foodbook_app/data/repositories/review_repository.dart';

class ReviewReportBloc extends Bloc<ReviewReportEvent, ReviewReportState> {
  final ReviewRepository reviewRepository;

  ReviewReportBloc(this.reviewRepository) : super(ReviewReportInitial()) {
    on<ReportReview>(_onReportReview);
  }

  Future<void> _onReportReview(ReportReview event, Emitter<ReviewReportState> emit) async {
    emit(ReviewReportLoading());
    try {
      print('Review report: ${event.reviewReport}');
      print('Reporting Review: ${event.review.title}');
      print('Reported By: ${event.user}');
      String reportId = await reviewRepository.reportReview(
        report: event.reviewReport,
        review: event.review,
        user: event.user
      );
      emit(ReviewReportSuccess(reportId));
    } catch (e) {
      emit(ReviewReportError(e.toString()));
    }
  }
}
