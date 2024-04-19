import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:foodbook_app/bloc/search_bloc/search_event.dart';
import 'package:foodbook_app/bloc/search_bloc/search_state.dart';
import 'package:foodbook_app/data/repositories/shared_preferences_repository.dart';


class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SharedPreferencesRepository repository = SharedPreferencesRepository();
  SearchBloc() : super(SearchInitial()){
    on<SearchButtonPressed>((event, emit) async {
      emit(SearchLoading());
    });
    // on<SignOutRequested>((event, emit) async {
    //   emit(Loading());
    //   try {
    //     await authRepository.signOut();
    //     emit(UnAuthenticated());
    //   } catch (e) {
    //     emit(AuthError(e.toString()));
    //     emit(UnAuthenticated());
    //   }
    // });
  //   on<SuggestionSelected>((event, emit) async {
  //   emit((SearchSuccess(event.query)));
  //   try {
  //     final results = await repository.saveSearchTerm(event.query);
  //     // emit(SearchSuccess(results));
  //   } catch (e) {
  //     emit(SearchFailure(e.toString()));
  //   }
  // });
      on<SearchWord>((event, emit) async {
      emit(SearchLoading());
      try {
        await repository.saveSearchTerm(event.query);
        emit(SearchLoading());
      } catch (e) {
        emit(SearchFailure(e.toString()));
      }
    });
  }
  
  

}