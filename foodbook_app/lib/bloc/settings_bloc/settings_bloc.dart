// settings_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateDaysSinceLastReviewEnabled>(_onUpdateDaysSinceLastReviewEnabled);
    on<UpdateNumberOfDays>(_onUpdateNumberOfDays);
    on<UpdateReviewsUploaded>(_onUpdateReviewsUploaded);
    on<UpdateLunchTime>(_onUpdateLunchTime);
  }

  void _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    emit(SettingsState(
      daysSinceLastReviewEnabled: prefs.getBool('daysSinceLastReviewEnabled') ?? true,
      numberOfDays: prefs.getInt('numberOfDays') ?? 4,
      reviewsUploaded: prefs.getBool('reviewsUploaded') ?? true,
      lunchTime: prefs.getBool('lunchTime') ?? true,
    ));
  }

  void _onUpdateDaysSinceLastReviewEnabled(
      UpdateDaysSinceLastReviewEnabled event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daysSinceLastReviewEnabled', event.enabled);
    emit(state.copyWith(daysSinceLastReviewEnabled: event.enabled));
  }

  void _onUpdateNumberOfDays(UpdateNumberOfDays event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('numberOfDays', event.days);
    emit(state.copyWith(numberOfDays: event.days));
  }

  void _onUpdateReviewsUploaded(UpdateReviewsUploaded event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reviewsUploaded', event.enabled);
    emit(state.copyWith(reviewsUploaded: event.enabled));
  }

  void _onUpdateLunchTime(UpdateLunchTime event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('lunchTime', event.enabled);
    emit(state.copyWith(lunchTime: event.enabled));
  }
}