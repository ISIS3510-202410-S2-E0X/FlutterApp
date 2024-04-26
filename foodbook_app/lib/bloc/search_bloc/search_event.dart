import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchWord extends SearchEvent {
  final String query;

  const SearchWord({required this.query});

  @override
  List<Object> get props => [query];
}

class AddSuggestion extends SearchEvent {
  final String suggestion;

  AddSuggestion({required this.suggestion});

  @override
  List<Object> get props => [suggestion];
}

class RemoveSuggestion extends SearchEvent {}

class SearchButtonPressed extends SearchEvent {
  final String query;

  const SearchButtonPressed({required this.query});

}
class SelectSuggested extends SearchEvent {
  final String suggestion;
  SelectSuggested({required this.suggestion});
  @override
  List<Object> get props => [suggestion];
}