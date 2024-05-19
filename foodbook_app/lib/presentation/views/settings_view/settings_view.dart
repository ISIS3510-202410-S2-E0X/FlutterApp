import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_bloc.dart';
import 'settings_event.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<SettingsBloc>().add(LoadSettings());  // Load settings initially

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Settings'),
          ),
          body: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('NOTIFICATIONS', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
              ),
              SwitchListTile(
                title: Text('Days since last review'),
                value: state.daysSinceLastReviewEnabled,
                onChanged: (bool value) {
                  context.read<SettingsBloc>().add(UpdateDaysSinceLastReviewEnabled(value));
                },
              ),
              ListTile(
                title: Text('Number of days'),
                trailing: Text('${state.numberOfDays} days'),
                onTap: () => _showDaysSelection(context, state.numberOfDays),
              ),
              SwitchListTile(
                title: Text('Reviews uploaded'),
                value: state.reviewsUploaded,
                onChanged: (bool value) {
                  context.read<SettingsBloc>().add(UpdateReviewsUploaded(value));
                },
              ),
              SwitchListTile(
                title: Text('Lunch time'),
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
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('OTHER', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
              ),
              ListTile(
                title: Text('Report a Bug'),
                onTap: () {
                  // Implement your navigation or functionality to report a bug
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
          title: Text("Select Number of Days"),
          content: DropdownButton<int>(
            value: currentDays,
            items: List.generate(7, (index) => DropdownMenuItem(
              value: index + 1,
              child: Text("${index + 1} days"),
            )),
            onChanged: (int? newValue) {
              context.read<SettingsBloc>().add(UpdateNumberOfDays(newValue!));
              Navigator.of(context). pop();
            },
          ),
        );
      },
    );
  }
}
