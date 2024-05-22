import 'package:foodbook_app/data/models/bug_report.dart';

abstract class BugReportState {}

class BugReportInitial extends BugReportState {}

class BugReportLoading extends BugReportState {}

class BugReportSuccess extends BugReportState {
  final String reportId;

  BugReportSuccess(this.reportId);
}

class BugReportDraftSuccess extends BugReportState {
  final String message;
  final BugReport? bugReport;

  BugReportDraftSuccess(this.message, {required this.bugReport});
}

class BugReportError extends BugReportState {
  final String error;

  BugReportError(this.error);
}
