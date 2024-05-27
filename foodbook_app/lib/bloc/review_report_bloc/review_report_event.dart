import 'package:foodbook_app/data/models/review.dart';

abstract class ReviewReportEvent {}

class ReportReview extends ReviewReportEvent {
  final String reviewReport;
  final Review review;
  final String user;

  ReportReview(this.reviewReport, this.review, this.user);
}