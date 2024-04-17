import 'dart:async';
import 'package:bloc/bloc.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial());

  List<String> suggestions = ["wok", "corral", "divino", "caserito", "x"];

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is SearchWord) {
      yield* _mapSearchWordToState(event);
    } else if (event is AddSuggestion) {
      yield* _mapAddSuggestionToState(event);
    } else if (event is RemoveSuggestion) {
      yield* _mapRemoveSuggestionToState(event);
    } else if (event is SearchButtonPressed) {
      yield* _mapSearchButtonPressedToState();
    }
  }

  Stream<SearchState> _mapSearchWordToState(SearchWord event) async* {
    List<String> searchedSuggestions = [];
    for (String suggestion in suggestions) {
      if (suggestion.contains(event.query)) {
        searchedSuggestions.add(suggestion);
      }
    }
    yield SearchSuccess(suggestions: searchedSuggestions);
  }

  Stream<SearchState> _mapAddSuggestionToState(AddSuggestion event) async* {
    suggestions.add(event.suggestion);
    yield SearchSuccess(suggestions: suggestions);
  }

  Stream<SearchState> _mapRemoveSuggestionToState(
      RemoveSuggestion event) async* {
    if (suggestions.isNotEmpty) {
      suggestions.removeLast();
      yield SearchSuccess(suggestions: suggestions);
    }
  }

  Stream<SearchState> _mapSearchButtonPressedToState() async* {
    // For demonstration purposes, adding a hardcoded search word
    final searchWord = "Search Word";
    suggestions.add(searchWord);
    yield SearchSuccess(suggestions: suggestions);
  }
}

