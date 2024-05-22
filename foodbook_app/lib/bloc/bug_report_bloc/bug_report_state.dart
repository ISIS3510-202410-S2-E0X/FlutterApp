abstract class BugReportState {}

class BugReportInitial extends BugReportState {}

class BugReportLoading extends BugReportState {}

class BugReportSuccess extends BugReportState {
  final String reportId;

  BugReportSuccess(this.reportId);
}

class BugReportError extends BugReportState {
  final String error;

  BugReportError(this.error);
}
