// settings_event.dart
abstract class SettingsEvent {}

class LoadSettings extends SettingsEvent {}

class UpdateDaysSinceLastReviewEnabled extends SettingsEvent {
  final bool enabled;

  UpdateDaysSinceLastReviewEnabled(this.enabled);
}

class UpdateNumberOfDays extends SettingsEvent {
  final int days;

  UpdateNumberOfDays(this.days);
}

class UpdateReviewsUploaded extends SettingsEvent {
  final bool enabled;

  UpdateReviewsUploaded(this.enabled);
}

class UpdateLunchTime extends SettingsEvent {
  final bool enabled;

  UpdateLunchTime(this.enabled);
}