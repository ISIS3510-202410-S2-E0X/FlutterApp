
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodbook_app/bloc/bookmark_internet_view_bloc/bookmark_internet_view_event.dart';
import 'package:foodbook_app/bloc/bookmark_internet_view_bloc/bookmark_internet_view_state.dart';

class BookmarkInternetViewBloc extends Bloc<BookmarkInternetViewEvent, BookmarkInternetViewState> {
  BookmarkInternetViewBloc() : super(BookmarkInternetInitial()) {
    on<BookmarksAccessInternet>((event, emit) async {
      emit(BookmarksInternet());
    });
    on<BookmarksAccessNoInternet>((event, emit) {
      emit(BookmarksNoInternet());
    });
  }

 

}