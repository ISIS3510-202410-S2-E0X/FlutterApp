import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodbook_app/data/models/bug_report.dart';

class BugReportDTO {
  Timestamp? date;
  final String bugType;
  final String description;
  final String severityLevel;
  final String stepsToReproduce;

  BugReportDTO({
    this.date,
    required this.bugType,
    required this.description,
    required this.severityLevel,
    required this.stepsToReproduce,
  });

  factory BugReportDTO.fromModel(BugReport bugReport) {
    return BugReportDTO(
      date: bugReport.date,
      bugType: bugReport.bugType,
      description: bugReport.description,
      severityLevel: bugReport.severityLevel,
      stepsToReproduce: bugReport.stepsToReproduce,
    );
  }

  BugReport toModel() {
    return BugReport(
      date: date,
      bugType: bugType,
      description: description,
      severityLevel: severityLevel,
      stepsToReproduce: stepsToReproduce,
    );
  }

  Map<String, dynamic> toJson(bool draft) {
    if (draft) {
      return {
        'bugType': bugType,
        'description': description,
        'severityLevel': severityLevel,
        'stepsToReproduce': stepsToReproduce,
      };
    }
    return {
      'date': date,
      'bugType': bugType,
      'description': description,
      'severityLevel': severityLevel,
      'stepsToReproduce': stepsToReproduce,
    };
  }

  factory BugReportDTO.fromJson(Map<String, dynamic> json) {
    return BugReportDTO(
      date: json['date'],
      bugType: json['bugType'],
      description: json['description'],
      severityLevel: json['severityLevel'],
      stepsToReproduce: json['stepsToReproduce'],
    );
  }
}
