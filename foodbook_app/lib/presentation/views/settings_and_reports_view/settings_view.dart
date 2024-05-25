import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/bug_report_bloc/bug_report_bloc.dart';
import 'package:foodbook_app/bloc/bug_report_bloc/bug_report_event.dart';
import 'package:foodbook_app/bloc/bug_report_bloc/bug_report_state.dart';
import 'package:foodbook_app/bloc/settings_bloc/settings_bloc.dart';
import 'package:foodbook_app/bloc/settings_bloc/settings_event.dart';
import 'package:foodbook_app/bloc/settings_bloc/settings_state.dart';
import 'package:foodbook_app/data/data_sources/database_provider.dart';
import 'package:foodbook_app/data/models/bug_report.dart';
import 'package:foodbook_app/data/repositories/bugs_report_repository.dart';
import 'package:foodbook_app/presentation/views/settings_and_reports_view/report_bugs_view.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void _checkForBugReportDraft(BuildContext context) {
    final bugReportBloc = context.read<BugReportBloc>();
    bugReportBloc.add(GetBugReportDraft());

    bugReportBloc.stream.listen((state) {
      if (state is BugReportDraftSuccess) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("It looks like you have a draft"),
              content: const Text('Would you like to load it?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    bugReportBloc.add(DeleteBugReportDraft());
                    _navigateToBugReportView(context);
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _navigateToBugReportView(context, state.bugReport);
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );
      } else {
        _navigateToBugReportView(context);
      }
    });
  }

  void _navigateToBugReportView(BuildContext context, [BugReport? bugReport]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<BugReportBloc>.value(
          value: BugReportBloc(BugReportRepository(DatabaseProvider())),
          child: BugReportView(initialBugReport: bugReport),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<SettingsBloc>().add(LoadSettings());  // Load settings initially

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
          ),
          body: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('NOTIFICATIONS', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
              ),
              SwitchListTile(
                title: const Text('Days since last review'),
                value: state.daysSinceLastReviewEnabled,
                onChanged: (bool value) {
                  context.read<SettingsBloc>().add(UpdateDaysSinceLastReviewEnabled(value));
                },
              ),
              ListTile(
                title: const Text('Number of days'),
                trailing: Text('${state.numberOfDays} days'),
                onTap: () => _showDaysSelection(context, state.numberOfDays),
              ),
              SwitchListTile(
                title: const Text('Reviews uploaded'),
                value: state.reviewsUploaded,
                onChanged: (bool value) {
                  context.read<SettingsBloc>().add(UpdateReviewsUploaded(value));
                },
              ),
              SwitchListTile(
                title: const Text('Lunch time'),
                value: state.lunchTime,
                onChanged: (bool value) {
                  context.read<SettingsBloc>().add(UpdateLunchTime(value));
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  "Changes in the number of days will be reflected once you make a new review or the last scheduled notification is sent",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('OTHER', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
              ),
              ListTile(
                title: const Text('Report a Bug'),
                onTap: () {
                    _checkForBugReportDraft(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDaysSelection(BuildContext context, int currentDays) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select Number of Days"),
          content: DropdownButton<int>(
            value: currentDays,
            items: List.generate(7, (index) => DropdownMenuItem(
              value: index + 1,
              child: Text("${index + 1} days"),
            )),
            onChanged: (int? newValue) {
              context.read<SettingsBloc>().add(UpdateNumberOfDays(newValue!));
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
