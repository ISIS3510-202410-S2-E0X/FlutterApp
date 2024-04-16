import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/search_bloc/search_event.dart';
import 'package:foodbook_app/bloc/search_bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent,SearchState>{
  SearchBloc() : super(InitialState()){
  on<SearchWord>((event, emit) {
    List<String> searchedTitles = [];
    for (String word in words) {
      if (word.contains(event.query)) {
        searchedTitles.add(word);
      }
    }
    emit(
      LoadedWords(words: searchedTitles)
    );

  });
  }
  List<String> words = ["wok", "corral", "divino", "caserito","x"];
  }
