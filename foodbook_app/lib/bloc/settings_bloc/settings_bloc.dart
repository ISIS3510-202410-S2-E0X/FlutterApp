import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/settings_bloc/settings_event.dart';
import 'package:foodbook_app/bloc/settings_bloc/settings_state.dart';
import 'package:foodbook_app/data/repositories/settings_manager.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsManager settingsManager;

  SettingsBloc(this.settingsManager) : super(SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateDaysSinceLastReviewEnabled>(_onUpdateDaysSinceLastReviewEnabled);
    on<UpdateNumberOfDays>(_onUpdateNumberOfDays);
    on<UpdateReviewsUploaded>(_onUpdateReviewsUploaded);
    on<UpdateLunchTime>(_onUpdateLunchTime);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    await settingsManager.initPrefs();
    emit(SettingsState(
      daysSinceLastReviewEnabled: await settingsManager.getBool('daysSinceLastReviewEnabled', true),
      numberOfDays: await settingsManager.getInt('numberOfDays', 4),
      reviewsUploaded: await settingsManager.getBool('reviewsUploaded', true),
      lunchTime: await settingsManager.getBool('lunchTime', true),
    ));
  }

  void _onUpdateDaysSinceLastReviewEnabled(
      UpdateDaysSinceLastReviewEnabled event, Emitter<SettingsState> emit) async {
    await settingsManager.setBool('daysSinceLastReviewEnabled', event.enabled);
    emit(state.copyWith(daysSinceLastReviewEnabled: event.enabled));
  }

  void _onUpdateNumberOfDays(UpdateNumberOfDays event, Emitter<SettingsState> emit) async {
    await settingsManager.setInt('numberOfDays', event.days);
    emit(state.copyWith(numberOfDays: event.days));
  }

  void _onUpdateReviewsUploaded(UpdateReviewsUploaded event, Emitter<SettingsState> emit) async {
    await settingsManager.setBool('reviewsUploaded', event.enabled);
    emit(state.copyWith(reviewsUploaded: event.enabled));
  }

  void _onUpdateLunchTime(UpdateLunchTime event, Emitter<SettingsState> emit) async {
    await settingsManager.setBool('lunchTime', event.enabled);
    emit(state.copyWith(lunchTime: event.enabled));
  }
}
