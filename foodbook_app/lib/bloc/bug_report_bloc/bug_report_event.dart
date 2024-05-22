import 'package:foodbook_app/data/models/bug_report.dart';

abstract class BugReportEvent {}

class ReportBug extends BugReportEvent {
  final BugReport bugReport;

  ReportBug(this.bugReport);
}

class SaveBugReportDraft extends BugReportEvent {
  final BugReport bugReport;

  SaveBugReportDraft(this.bugReport);
}

class DeleteBugReportDraft extends BugReportEvent {
  DeleteBugReportDraft();
}