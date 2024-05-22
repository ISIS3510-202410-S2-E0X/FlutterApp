import 'package:cloud_firestore/cloud_firestore.dart';

class BugReport {
  final Timestamp date;
  final String bugType;
  final String description;
  final String severityLevel;
  final String stepsToReproduce;

  BugReport({
    required this.date,
    required this.bugType,
    required this.description,
    required this.severityLevel,
    required this.stepsToReproduce,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'bugType': bugType,
      'description': description,
      'severityLevel': severityLevel,
      'stepsToReproduce': stepsToReproduce,
    };
  }

  factory BugReport.fromJson(Map<String, dynamic> json) {
    return BugReport(
      date: json['date'] as Timestamp,
      bugType: json['bugType'],
      description: json['description'],
      severityLevel: json['severityLevel'],
      stepsToReproduce: json['stepsToReproduce'],
    );
  }
}
