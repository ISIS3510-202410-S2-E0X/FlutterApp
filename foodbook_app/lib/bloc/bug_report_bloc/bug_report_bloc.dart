import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/bug_report_bloc/bug_report_event.dart';
import 'package:foodbook_app/bloc/bug_report_bloc/bug_report_state.dart';
import 'package:foodbook_app/data/repositories/bugs_report_repository.dart';

class BugReportBloc extends Bloc<BugReportEvent, BugReportState> {
  final BugReportRepository bugReportRepository;

  BugReportBloc(this.bugReportRepository) : super(BugReportInitial()) {
    on<ReportBug>(_onReportBug);
    on<SaveBugReportDraft>(_onSaveBugReportDraft);
    on<DeleteBugReportDraft>(_onDeleteBugReportDraft);
  }

  Future<void> _onReportBug(ReportBug event, Emitter<BugReportState> emit) async {
    emit(BugReportLoading());
    try {
      print('Bug report: ${event.bugReport}');
      String reportId = await bugReportRepository.reportBug(bugReport: event.bugReport);
      emit(BugReportSuccess(reportId));
    } catch (e) {
      emit(BugReportError(e.toString()));
    }
  }

  Future<void> _onSaveBugReportDraft(SaveBugReportDraft event, Emitter<BugReportState> emit) async {
    try {
      await bugReportRepository.reportBugDraft(event.bugReport);
      emit(BugReportSuccess("Draft saved locally"));
    } catch (e) {
      emit(BugReportError(e.toString()));
    }
  }

  Future<void> _onDeleteBugReportDraft(DeleteBugReportDraft event, Emitter<BugReportState> emit) async {
    try {
      await bugReportRepository.deleteBugReportDraft();
      emit(BugReportSuccess("Draft deleted"));
    } catch (e) {
      emit(BugReportError(e.toString()));
    }
  }
}
