// settings_state.dart
class SettingsState {
  final bool daysSinceLastReviewEnabled;
  final int numberOfDays;
  final bool reviewsUploaded;
  final bool lunchTime;

  SettingsState({
    this.daysSinceLastReviewEnabled = true,
    this.numberOfDays = 4,
    this.reviewsUploaded = true,
    this.lunchTime = true,
  });

  SettingsState copyWith({
    bool? daysSinceLastReviewEnabled,
    int? numberOfDays,
    bool? reviewsUploaded,
    bool? lunchTime,
  }) {
    return SettingsState(
      daysSinceLastReviewEnabled: daysSinceLastReviewEnabled ?? this.daysSinceLastReviewEnabled,
      numberOfDays: numberOfDays ?? this.numberOfDays,
      reviewsUploaded: reviewsUploaded ?? this.reviewsUploaded,
      lunchTime: lunchTime ?? this.lunchTime,
    );
  }
}