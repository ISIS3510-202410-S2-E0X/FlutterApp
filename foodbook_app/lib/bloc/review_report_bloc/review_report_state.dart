abstract class ReviewReportState {}

class ReviewReportInitial extends ReviewReportState {}

class ReviewReportLoading extends ReviewReportState {}

class ReviewReportSuccess extends ReviewReportState {
  final String reportId;

  ReviewReportSuccess(this.reportId);
}

class ReviewReportError extends ReviewReportState {
  final String error;

  ReviewReportError(this.error);
}
