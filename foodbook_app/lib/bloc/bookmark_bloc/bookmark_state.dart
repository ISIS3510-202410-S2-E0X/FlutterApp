

abstract class BookmarkState {}

class BookmarkInitial extends BookmarkState {}

class BookmarkLoaded extends BookmarkState {
  final bool isBookmarked;
  BookmarkLoaded(this.isBookmarked);
}